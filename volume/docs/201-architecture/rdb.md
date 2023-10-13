# [まとめ中]RDB設計
RDB設計についての勘所についてまとめるページ

## 残りまとめたいもの
- data type
- リレーション設計
- 設計サンプル（カラム名予約、n:n設計）
- SQLアンチパターン

## SQLアンチパターン
SQLに関するアンチパターンをまとめたもの。
自分が関わったことのあるテーブルについて記載。

[ITエンジニアはSQLアンチパターンを読むべし！ 軽いまとめ](https://tech-blog.tsukaby.com/archives/857)

### 1. Jaywalking（信号無視）
カンマ区切りの値を入れること。半構造データみたいになる。

> 開発者はよく、「多対多」の関連を表現する交差テーブルの作成を避けるために、カンマ区切りのリストを使います。
> 私はこのアンチパターンをJaywalkingと名づけました。どちらも、"intersection"を避けようとする行為だからです。

| book_id | book_name | book_tags |
| - | - | - |
| 1 | Spring MVC | Java,Spring,SpringMVC |
| 2 | はじめてのScala | Scala,入門 |

#### 解決策：交差テーブルを作成

| book_id | book_name |
| - | - |
| 1 | Spring MVC |
| 2 | はじめてのScala |

| book_tag_id | book_tag_name |
| - | - |
| 1 | Java |
| 2 | Spring |
| 3 | SpringMVC |
| 4 | Scala |
| 5 | 入門 |

| book_id | book_tag_id |
| - | - | 
| 1 | 1 |
| 1 | 2 |
| 2 | 3 |
| 2 | 4 |
| 2 | 5 |


### 5. EAV (Entity Attribute Value)
Entity Attribute Value（以下EAV）では次のような項目を持ったテーブルが設計される。

| 名称 | 役割 |
| - | - |
| Entity | 親テーブルに対応した外部キーを格納 |
| Attribute | カラム名に相当する属性名を指定 |
| Value | 属性の値 |

| book_id |
| - | - |
| 1 |

| book_id | attribute | value |
| - | - | - |
| 1 | name | 本名 |
| 1 | release_date | 2020/9/24 |
| 1 | price | 5 |

- メリット
    - テーブルの列数を削減できる
    - 新規の属性を追加する際に列数を増加しなくて良い
    - 属性が存在しない列にNULLが入りNULLだらけのテーブルにならない
    - データベースの構造は単純になる
- デメリット
    - データの取得が冗長化する
    - 特定の属性にNOT NULL制約を設定できない
    - データ型を使用できない
    - 外部制約キーを使用できない
    - 動的に属性名が増えるため整合性が担保しづらい


#### 解決策：サブタイプでのモデリングを行う
![](https://camo.qiitausercontent.com/3b3c8cf3b4a65cca1fd47f5765fd6c6209e4b40b/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e616d617a6f6e6177732e636f6d2f302f3233363534322f62643133646131332d613063312d636234302d626365662d3434373662343830396333382e706e67)

大きく分けて4種類の継承方法がある。

- シングルテーブル継承
- 具象テーブル継承
- クラステーブル継承
- 半構造化データ

シングルテーブル継承で作成する場合

| book_id | book_name | book_release_date | book_price |
| - | - | - | - |
| 1 | 本名 | 2020/9/24 | 5 |

#### 参考：EAV (Entity Attribute Value)
- [SQLアンチパターン　Entity Attribute Value](https://qiita.com/fktnkit/items/0ff462640e00deecfc6d)
- [SQLアンチパターン勉強会　第五回：EAV(エンティティ・アトリビュート・バリュー)](https://qiita.com/skyc_lin/items/37365a36416d0dc42431)

### 7. Multi Column Attribute
複数列属性を持つようなアンチデザインパターン。Jaywalkingに似ている。

- 属性の検索が複雑になる
- 属性の追加・削除がしにくい
- 属性の一意性を保証できない
- 属性列の増加が起こりうる

| book_id | book_name | book_tag_1 | book_tag_2 | book_tag_3 | book_tag_4 |
| - | - | - | - | - | - |
| 1 | Spring MVC | Java | Spring | SpringMVC | NULL |
| 2 | はじめてのScala | Scala | 入門 | NULL | NULL |

#### 解決策：交差テーブルを作成
同じ意味を持つ値は、1つの列に格納して別テーブルとし、1:nやn:nのリレーションを作成すれば良い。

| book_id | book_name |
| - | - |
| 1 | Spring MVC |
| 2 | はじめてのScala |

| book_tag_id | book_tag_name |
| - | - |
| 1 | Java |
| 2 | Spring |
| 3 | SpringMVC |
| 4 | Scala |
| 5 | 入門 |

| book_id | book_tag_id |
| - | - | 
| 1 | 1 |
| 1 | 2 |
| 2 | 3 |
| 2 | 4 |
| 2 | 5 |

#### 参考：Multi Column Attribute


<!-- ------------------------------------------------- -->

## リレーション
- 1:1
- 1:n
- n:n


- t_{table1}_{table2}

### 参考：
- [やさしい図解で学ぶ　中間テーブル　多対多　概念編](https://qiita.com/ramuneru/items/db43589551dd0c00fef9)

## 規約例
設計時に利用されている規約についていくつか提示する。
公式に決まっているものではないので、人によって採用基準が異なる。

### 構造規約
- 基本的に第三正規系以上の正規系
- 正しくリレーションを張ること。静的解析ツールとの連携に優位。

### 命名規約
- 日本語の排除
    - 文字コードによるリスク排除
- ローマ字(ヘボン式)の利用可否
    - 基本的には不要にできる
- 大文字、小文字の統一
- 単数形、複数形の統一
- 複数単語命名規則の統一
    - スネークケースが多い
        - PostgreSQLはケースインセンシティブ
- 略称利用ルール設定
    - 略称多用は可読性に悪影響
- テーブル名の役割プレフィックス
    - 例
        - m:マスタ
        - t:トランザクション 
        - h:ヒストリ 
        - v:ビュー 
        - mv:マテビュー
- カラム名のプレフィックスに（テーブル名の役割プレフィックスを省略して）テーブル名をつける
    - データベース内でカラム名がほとんど重複しない
    - 例
        - t_merchandise.t_merchandise_id
        - t_merchandise.t_merchandise_m_merchandise_category_id
        - t_merchandise.merchandise_id (テーブル名の役割プレフィックスを省略)
- カラム名予約
    - よく使う情報についてはあらかじめ共通名を付けておく
    - 例
        - created_at : 作成時刻

<!-- examlple -------------------------------------------- -->

## 個人的な採用方針
- 設計の一意性を優先させる
- 名前が長くなる等の冗長性対策の優先度は下げる

### 採用項目
- 構造規約
    - 第三正規系以上の正規系
    - 正しくリレーションを張る
- 命名規約
    - 日本語利用不可
    - ローマ字利用不可
    - 小文字統一
    - 単数形統一
    - スネークケース採用
    - 略称利用ルール設定は検討中
        - id, cdのみ採用
    - テーブル名の役割プレフィックス
    - カラム名のテーブル名プレフィックス（テーブル名の役割プレフィックスを省略）
    - カラム名予約
        - creation_user_id
        - creation_datetime
        - update_user_id
        - update_datetime 

### [途中]設計サンプル
社員n : 1所属 の関係

#### DDL
```sql
create database sample;
create schema app;

create table app.m_user_role (
	user_role_cd character(2),
	user_role_name character(20) not null,
	CONSTRAINT m_user_role_pkey PRIMARY KEY (user_role_cd)
);

create table app.t_user (
	user_id character(26),
	user_name character(50) not null,
    user_user_role_cd character(2),
	CONSTRAINT t_user_pkey PRIMARY KEY (user_id),
	CONSTRAINT t_user_user_role_cd_fkey FOREIGN KEY (user_user_role_cd)
        REFERENCES app.m_user_role (user_role_cd) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);

create table app.t_circle (
	circle_id character(26),
	circle_name character(50) not null,
	CONSTRAINT t_circle_pkey PRIMARY KEY (circle_id)
);

create table app.t_circle_map (
	circle_id character(26),
    user_id character(26),
	CONSTRAINT t_circle_map_pkey PRIMARY KEY (circle_id, user_id),
    CONSTRAINT t_circle_circle_id_fkey FOREIGN KEY (circle_id)
        REFERENCES app.t_circle (circle_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT t_circle_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES app.t_user (user_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);

```

```sql
drop table app.t_circle_map;
drop table app.t_circle;
drop table app.t_user;
drop table app.m_user_role;
```

### [途中]type利用基準
データベースにより適切なタイプが異なる。参考で提示

- char ： 文字列長をアプリ側で固定する場合(ex. ulid) 
- ulid : char[26]
- text ： 文字列長が不定 or 未調査の場合 
- datetime ： 年月日時 
- date : 年月日(ex. 1979-01-01) 

## 参考
- [【データベース設計】 テーブル名、カラム名の名前の付け方（命名規則）](https://www.softel.co.jp/blogs/tech/archives/627)
- [データベースの命名規則](https://avinton.com/academy/database-naming-conventions/)
- [SQLアンチパターン勉強会　第五回：EAV(エンティティ・アトリビュート・バリュー)](https://qiita.com/skyc_lin/items/37365a36416d0dc42431)

## メモ
SQLアンチパターン
ジェイウォーク
EntityAttributeValue:EAV
SQLインジェクション
[【データベース設計】 テーブル名、カラム名の名前の付け方（命名規則）](https://www.softel.co.jp/blogs/tech/archives/627)
[「SQLアンチパターン」まとめ](https://qiita.com/taiteam/items/33aebded2842808e0391)
