# indexの更新
indexのmappingについて更新したい状況がある。新規追加するmappingであれば、単に既存indexのmappingを更新すればよい。
一方で、typeやanalyzerの変更を伴う場合、indexを作り直す必要がある。  
indexの作り直しや切り替えは基本的に下記の流れで実施可能。

1. new_index作成
1. new_indexにデータ投函
    - old_indexからreindexする、データを再投函するなど
1. old_indexからnew_indexに紐づけを変更
    - Aliasを切り替える、依存先の設定を変更するなど
1. 不要な場合old_indexを削除

- [参考：[Opensearch]Aliasを便利につけるRakeタスクを作りたい](https://qiita.com/namarin/items/79ffed6305bccbb14ccb#%E9%81%8B%E7%94%A8%E6%99%82%E3%81%AEindex%E3%81%AE%E3%83%9E%E3%83%83%E3%83%94%E3%83%B3%E3%82%B0%E3%83%89%E3%82%AD%E3%83%A5%E3%83%A1%E3%83%B3%E3%83%88%E3%81%AE%E6%A7%8B%E9%80%A0%E5%A4%89%E6%9B%B4%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6)

## reindexする
あまり速度でない感。再投函の方が良いかも。

```
POST /_reindex
{
  "source": {
    "index": "old_index"
  },
  "dest": {
    "index": "new_index"
  }
}
```

## Aliasの切り替え
index作成時にエイリアス指定できるが、運用上エイリアスの削除と追加を同時に行うパターンが多いと思う。

```
POST /_aliases
{
  "actions": [
    {
      "remove": {
        "index": "old_index",
        "alias": "aliases"
      }
    },
    {
      "add": {
        "index": "new_index",
        "alias": "aliases"
      }
    }
  ]
}
```