# 1対nをOpensearchで検索する
主に以下のパターンが取れる。ユースケースで最適なアプローチは変わってくる。

- nested field type を持たせて半構造リストを保持させる
- join field type を用いて親子関係を持たせる
    - 1側にnの情報をまとめるとdocが肥大化する場合に1とnでdocを分ける手法
    - n側のdocが圧倒的に多い場合に特に効果的
- Application側でjoinする
    - 2つの検索に分けて必要な情報を取得する
    - https://www.elastic.co/guide/en/elasticsearch/guide/current/application-joins.html

## nested field type を持たせて半構造リストを保持させる
半構造データをmapとするパターン。

作りとしては次のようなjson側をデータに持つようなイメージ。

| _id     | user_id | user_name | activity                                                                                                 |
| ------- | ------- | --------- | -------------------------------------------------------------------------------------------------------- |
| user_00 | 00      | admin     | [{"activity_id": "000", "activity_name": "活動名0"}, {"activity_id": "001", "activity_name": "活動名1"}] |
| user_99 | 99      | guest     | [{"activity_id": "002", "activity_name": "活動名2"}]                                                     |

### index作成
```
PUT user_activity
{
  "settings":{
    "analysis":{
      "analyzer": {
          "kuromoji_text": {
              "char_filter": [
              "icu_normalizer"                    
              ],
              "tokenizer": "kuromoji_tokenizer",
              "filter": [
              "kuromoji_baseform",
              "kuromoji_part_of_speech",
              "cjk_width",
              "ja_stop",
              "kuromoji_stemmer",
              "lowercase"
              ]
          }
      }
    }
  },
  "mappings": {
    "properties": {
        "user_id" : {
            "type" : "text",
            "fields" : {
                "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
                }
            }
        },
        "user_name" : {
            "type" : "text",
            "fields" : {
                "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
                }
            },
            "analyzer" : "kuromoji_text"
        },
        "activity" : {
          "type" : "nested",
          "properties": {
            "activity_id": { "type": "keyword" },
            "activity_name": { "type": "keyword" },
            "activity_date": { "type": "date" }
          }
        }
    }
  }
}
```

### doc投函
```
POST user_activity/_bulk
{ "index" : { "_index" : "user_activity", "_id" : "user_00" } }
{ "id": "user_00", "user_id": "00", "user_name": "admin", "activity": [{ "activity_id": "000", "activity_name": "活動0", "activity_date": "2023-01-01"},{ "activity_id": "001", "activity_name": "活動1", "activity_date": "2023-02-01" }]}
{ "index" : { "_index" : "user_activity", "_id" : "user_99" } }
{ "id": "user_99", "user_id": "99", "user_name": "admin", "activity": [{ "activity_id": "002", "activity_name": "活動2", "activity_date": "2023-01-01" }]}
```

### 検索例
- 登録したすべてのdocを取得（2つ）
```
get user_activity/_search
```

- inner hit で activityはactivity_dateの降順で並び変えて先頭の5つを取得する
- inner hit するすべてのactivityについてactivity_dateで月別集計する
```
POST user_activity_n/_search
{
  "track_total_hits": true,
  "query": {
    "nested": {
      "path": "activity",
      "score_mode": "max",
      "query": {
        "match_all": {}
      },
      "inner_hits": {
        "_source": true,
        "size": 5,
        "sort": [
          {
            "activity.activity_date": {
              "order": "desc"
            }
          }
        ],
        "highlight": {
            "fields": {
                "*": { }
            }
        }
      }
    }
  },
  "aggs": {
    "nested_activity": {
      "nested": {
        "path": "activity"
      },
      "aggs": {
        "monthly_activity": {
          "date_histogram": {
            "field": "activity.activity_date",
            "calendar_interval": "month",
            "format": "yyyy-MM"
          }
        }
      }
    }
  }
}
```


## join field type を用いて親子関係を持たせる
1側にnレコードを結合してデータを入れると1つあたりのdocサイズが肥大化し、検索効率に悪影響が出る場合がある。  
Opensearchではjoin typeによって親子関係を示して一つのindexの中でdocを保持する方法を提供している。  
ただし、一つのindexで親側をnにすることはできない。この場合、indexを分けて作成することで回避はできそう。

作りとしては一つ非正規化テーブルに性質の異なるレコードを入れるようなイメージ。  

| _id | user_id | user_name | activity_id | activity_name | join_field.name | join_field.parent |
| - | - | - | - | - | - | - |
| user_00 | 00 | admin | | | user | |
| user_99 | 99 | guest | | | user | |
| activity_000 | 00 |  | 000 | 活動名0 | activity | user_00 |
| activity_001 | 00 |  | 001 | 活動名1 | activity | user_00 |
| activity_002 | 99 |  | 002 | 活動名2 | activity | user_99 |

[参考：エラー番号とエラーインスタンスででjoin_typeを用いるパターン](https://www.highlight.io/blog/opensearch-for-a-write-heavy-workload)

### index作成
例で提示しているテーブルよりいくつかpropertyを追加する。

```
PUT user_activity
{
  "settings":{
    "analysis":{
      "analyzer": {
          "kuromoji_text": {
              "char_filter": [
              "icu_normalizer"                    
              ],
              "tokenizer": "kuromoji_tokenizer",
              "filter": [
              "kuromoji_baseform",
              "kuromoji_part_of_speech",
              "cjk_width",
              "ja_stop",
              "kuromoji_stemmer",
              "lowercase"
              ]
          }
      }
    }
  },
  "mappings": {
    "properties": {
        "user_id" : {
            "type" : "text",
            "fields" : {
                "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
                }
            }
        },
        "user_name" : {
            "type" : "text",
            "fields" : {
                "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
                }
            },
            "analyzer" : "kuromoji_text"
        },
        "join_field": {
            "type": "join",
            "relations": {
                "user": "activity" 
            }
        },
        "activity_id" : {
          "type" : "text",
          "fields" : {
              "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
              }
          }
        },
        "activity_name" : {
          "type" : "text",
          "fields" : {
              "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
              }
          },
          "analyzer" : "kuromoji_text"
        },
        "activity_date": {
          "type": "date"
        }
    }
  }
}
```

### join fieldのdoc投函
```
POST user_activity/_bulk
{ "index" : { "_index" : "user_activity", "_id" : "user_00" } }
{ "id": "user_00", "user_id": "00", "user_name": "admin", "join_field": { "name": "user" } }
{ "index" : { "_index" : "user_activity", "_id" : "user_99" } }
{ "id": "user_99", "user_id": "99", "user_name": "guest", "join_field": { "name": "user" } }
{ "index" : { "_index" : "user_activity", "_id" : "activity_000", "routing": "user_00" }  }
{ "id": "activity_000", "user_id": "00", "activity_id": "000", "activity_name": "活動名0", "activity_date": "2023-01-01", "join_field": { "name": "activity", "parent": "user_00" } }
{ "index" : { "_index" : "user_activity", "_id" : "activity_001", "routing": "user_00" } }
{ "id": "activity_001", "user_id": "00", "activity_id": "001", "activity_name": "活動名1", "activity_date": "2023-02-01", "join_field": { "name": "activity", "parent": "user_00" } }
{ "index" : { "_index" : "user_activity", "_id" : "activity_002", "routing": "user_99" } }
{ "id": "activity_002", "user_id": "99", "activity_id": "002", "activity_name": "活動名2", "activity_date": "2023-01-01", "join_field": { "name": "activity", "parent": "user_99" } }
```

### join fieldのクエリ例

- 登録したすべてのdocを取得（5つ）
```
get user_activity/_search
```

- activtyで親のuser_nameがadminのものをactivity_dateの降順で取得（2つ）
- activityをactivity_dateで3年以内で月別集計する
```
POST user_activity/_search
{
  "track_total_hits": true,
  "sort": [
    {
      "activity_date": {
        "order": "desc"
      }
    }
  ], 
  "query": {
    "has_parent": {
      "parent_type": "user",
      "query": {
        "match": {
          "user_name.keyword": "admin"
        }
      }
    }
  },
  "aggs":{
    "monthly_activity": {
      "filter": {
        "range": {
          "activity_date": {
            "gte": "now-3y/M",
            "lte": "now/M"
          }
        }
      },
      "aggs":{
        "monthly_activity_3y": {
          "date_histogram": {
            "field": "activity_date",
            "calendar_interval": "month",
            "format": "yyyy-MM"
          }
        }
      }
    }
  }
}
```

- 登録したuserで子にactivityをもつものを取得（2つ）
- 各userでinner hitしたactivityをactivity_idの降順で最大5つまで取得
```
POST user_activity/_search
{
  "track_total_hits": true,
  "query": {
    "has_child": {
      "type": "activity",
      "score_mode": "max",
      "query": {
        "match_all": {}
      },
      "inner_hits": {
        "_source": true,
        "size": 5,
        "sort": [
          {
            "activity_id.keyword": {
              "order": "desc"
            }
          }
        ],
        "highlight": {
            "fields": {
                "*": { }
            }
        }
      }
    }
  }
}
```

### できないこと
- inner hitしたものの先頭を用いて集計やソートを行う