# [まとめ中]Domain Driven Design

各設計思想において、微妙に名前の使い方が異なるので注意すること（Entityなど）。

- Layerd Architecture
    - 元の提案設計
- Hexagonal Architecture
    - 後述する設計思想に比べると、制約が緩め
- Onion Architecture
    - 学習コストと制約のバランスが良い
- Clean Architecture
    - 全体構造が詳細に描かれており、学習コストが高い

# Onion Architecture
Onion Architecture は以下の4レイヤからなる、アーキテクチャである。
- Domain Model layer
    - Value Object
    - Entity
- Domain Services layer
    - Repository
    - Domain Service
- Application Services layer
- Outer layer
    - User Interfaces
    - Test
    - Infrastructure


![](https://tech.ovoenergy.com/content/images/2018/12/OnionLayersLabelled-2.png)

![](ddd.dio.png)

## Domain Service
## Repository
| method  | 責務                       |
| ------- | -------------------------- |
| find_by | idで一つのデータを取り出す |
| listing | 一覧                       |
| store   | 永続化                     |
| remove  | 削除                       |

## ユビキタス言語 ubiquitous
- ドメインエキスパート専門用語
- 開発者専門用語
- 発見的ユビキタス言語

[ドメイン駆動設計(DDD)との格闘 - ユビキタス言語には不屈の闘志が不可欠](https://blog.flinters.co.jp/entry/2021/03/10/150000)

# 参考
- [Onion Architecture - Cutting onions, without the tears!](https://tech.ovoenergy.com/onion-architecture/)
- [ボトムアップドメイン駆動設計](https://nrslib.com/bottomup-ddd/)
- [クリーンアーキわからんかった人のためのオニオンアーキテクチャ](https://zenn.dev/streamwest1629/articles/no-clean_hello-onion-architecture)
- [Clean Architectureの構造的な過ちについて](https://qiita.com/bigen1925/items/4acb08db76abd6036472)

# 手段
## FastAPI
- [Python 製 Web フレームワークを Flask から FastAPI に変えた話](https://note.com/navitime_tech/n/nc0381517d067)
- [【徹底解説】FastAPIの特徴と課題点](https://zenn.dev/nameless_sn/articles/why_fastapi_development)