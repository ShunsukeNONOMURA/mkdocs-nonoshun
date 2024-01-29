# Opensearchで日本語を検索する
opensearchはデフォルトだと日本語で形態素解析ができないためプラグインを導入する。  
ここではkuromojiのプラグインを導入している時のindex構築例を示す。  

## index作成例
booksのタイトルを日本語検索できるように設定する。

```
PUT books
{
  "settings": {
    "analysis": {
      "analyzer": {
        "kuromoji_text": {
          "type": "custom",
          "char_filter":[
                "icu_normalizer"
          ],
          "tokenizer": "kuromoji_tokenizer",
          "filter": [
            "kuromoji_baseform",
            "kuromoji_part_of_speech",
            "ja_stop",
            "kuromoji_number",
            "kuromoji_stemmer"
          ]
        }
      }
    }
  },
  "mappings": {
      "properties": {
        "book_title": {
          "type": "text",
          "analyzer": "kuromoji_text",
          "index": true
       }
    }
  }
}
```

## doc投函
```
POST books/_bulk
{ "index" : { "_index" : "books", "_id" : "4" } }
{ "id": 4, "book_title": "坊っちゃん" }
{ "index" : { "_index" : "books", "_id" : "5" } }
{ "id": 5, "book_title": "注文の多い料理店" }
{ "index" : { "_index" : "books", "_id" : "6" } }
{ "id": 6, "book_title": "学問のすすめ" }
```

## 検索実行
```
GET books/_search
{
    "query": {
        "terms": {
          "book_title": [
            "注文"
          ]
        }
    }
}
```

検索結果。

```
{
  "took": 0,
  "timed_out": false,
  "_shards": {
    "total": 1,
    "successful": 1,
    "skipped": 0,
    "failed": 0
  },
  "hits": {
    "total": {
      "value": 1,
      "relation": "eq"
    },
    "max_score": 1,
    "hits": [
      {
        "_index": "books",
        "_id": "5",
        "_score": 1,
        "_source": {
          "id": 5,
          "book_title": "注文の多い料理店"
        }
      }
    ]
  }
}
```

## 形態素解析の確認
```
GET /books/_analyze
{
  "analyzer": "kuromoji_text",
  "text" : "すもももももももものうち"
}
```

形態素解析結果。名詞（word）だけ抜き出している。
```
{
  "tokens": [
    {
      "token": "すもも",
      "start_offset": 0,
      "end_offset": 3,
      "type": "word",
      "position": 0
    },
    {
      "token": "もも",
      "start_offset": 4,
      "end_offset": 6,
      "type": "word",
      "position": 2
    },
    {
      "token": "もも",
      "start_offset": 7,
      "end_offset": 9,
      "type": "word",
      "position": 4
    }
  ]
}
```

## 参考
- [OpenSearchで日本語検索設定を試してみる](https://sheltie-garage.xyz/tech/2023/05/opensearch%E3%81%A7zozotown%E5%BC%8F%E6%97%A5%E6%9C%AC%E8%AA%9E%E6%A4%9C%E7%B4%A2%E8%A8%AD%E5%AE%9A%E3%82%92%E8%A9%A6%E3%81%97%E3%81%A6%E3%81%BF%E3%82%8B/)