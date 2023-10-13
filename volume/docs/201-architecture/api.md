# [まとめ中]API設計

## 書きたいメモ
REST
Resource
Action
HTTP Status
設計サンプル
versionを含める
    v1, v2
    破壊的更新の場合に別パスにする (v1.0.1, v1.1.0 -> v1)
    マイナーバージョン以下は更新されても互換性を保つので省略

## REST API
REpresentational State Transferの略。

- Representational →具象化された
- State →状態の
- Transfer →転送

「REST」は標準化ではなくあくまで設計思想
WebAPI設計に絶対解はないが、ベタープラクティスはある

「RESTの4原則」というものがあり、これを満たすものを「RESTfulなシステム」と呼んだりします

「REST API」とは先ほどのRESTの4原則に則ったAPI

## RESTの4原則
HTTPを設計した中心人物であるRoy Fielding氏が2000年に提唱したもの

- 統一インターフェース
    - HTTPメソッドでJSON形式であるなど
- アドレス可能性
    - URIで情報を表現する
- 接続性
    - 情報にはハイパーリンクを含めることができる
    - 情報Aが持つ情報Bの詳細についてリンクからたどれる
- ステートレス性
    - セッション管理しない

「リソース(リソース指向アーキテクチャ(ROA))」という概念

xml形式

## Process
ProcessCode = RRRA
ProcessName = ResouceNameActionName

## Recouse
3桁のコードで示すこと

## リソース

- collection
- object

## URI(Uniformed Resource Identifier)
覚えやすく、どんな機能を持つURIなのかがひと目でわかる

- 短くて入力しやすい
    - 長い場合、不要な情報があったり、重複するものがあったりするかも
- 人間が読んで理解できる
- 大文字小文字が混在していない
- サーバーアーキテクチャが反映されていない
- ルールが統一されている
- バージョン番号が含まれたURI
    - hostname/api/v1/hogehoge のような形
- リソース名
    - 名詞

特に決まっていない

- ケース
    - キャメル、スネーク、スパイナルなど
    - 開発言語に寄せるなど

## URIサンプル

collection
collection/object_id
collection/object_id/collection
/collection

user
user/{user_id}
user/{user_id}/message
search
search/user

| リソース | POST | GET | PUT | DELETE |
| - | - | - | - | - |
| /customer | 新しい顧客を作成 | すべての顧客を取得 | 顧客を一括更新 | すべての顧客を削除 |
| /customer/1 | エラー | 顧客 1 の詳細を取得 | 顧客 1 の詳細を更新 (顧客 1 が存在する場合) | 	顧客 1 を削除 |
| /customer/1/orders | 顧客 1 の新しい注文を作成 | 顧客 1 のすべての注文を取得 | 	顧客 1 の注文を一括更新 | 顧客 1 のすべての注文を削除 |

[HTTP メソッドに関する API 操作の定義](https://learn.microsoft.com/ja-jp/azure/architecture/best-practices/api-design#define-api-operations-in-terms-of-http-methods)


## API Action
API Actionはおおむね次の８種類に分類。必要に応じて拡張する。

| action-code | action | 説明 | 安全性 | 冪等性 | HTTP Method | 備考 |
| - | - | - | - | - | - | - |
| 0 | Get | 単一のリソースを取得する操作。 | あり | 要 | GET |
| 1 | List | 全リソースを絞り込まずに一覧する操作。ページングは動作想定。 | あり | 要 | GET |
| 2 | Create | リソースを新規に作成する操作。 | なし | 要 | POST |
| 3 | Patch | 既存リソースを部分的に変更する操作。 | なし | 不要 | PATCH |ユーザの名前だけを更新するなど。使いどころがよくわからない
| 4 | Upsert | リソース全体を置換、既存リソースがなければ作成する操作。 | なし | 要 | PUT | 名前を変えたユーザを更新するなど。
| 5 | Delete | リソースを削除する操作。 | なし | 要 | DELETE |
| 6 | Task | その他、上記に分類できない複雑な更新や計算などの操作。<br>バッチ処理など。 | なし | 不要 | POST |
| 7 | Query | 特定の問い合わせ処理を要求する。検索結果など返り値データを再利用してもよい。データの永続化の必要性は問わない。 | あり | 要 | POST |

## HTTP Status Codes

## HTTP Status Code
- 100系　情報系
- 200系 正常系
- 300系 転送系 
- 400系 クライアントエラー
- 500系 サーバーエラー

[HTTPステータス コード (HTTP status codes)](https://so-zou.jp/software/tech/network/tech/http/status-code/)

| GET | HTTP Status Codes (正常系) |
| - | - |
| GET | 200 |
| POST | 201 |
| PUT | 200 |
| DELETE | 200 |

## 設計サンプル

## 参考
- [翻訳: WebAPI 設計のベストプラクティス](https://qiita.com/mserizawa/items/b833e407d89abd21ee72)
- [Developers.IO 2018 で「API 設計」の話をしてきた #cmdevio2018](https://dev.classmethod.jp/articles/cmdevio2018-api/)

## 参考：企業 REST API
- [Spotify](https://developer.spotify.com/documentation/web-api)
- [Twitter](https://developer.twitter.com/en/docs/twitter-api/migrate/twitter-api-endpoint-map)
