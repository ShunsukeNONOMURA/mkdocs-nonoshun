# 命名規則
命名規則に関するあれこれをまとめていくページ。  
あらかじめ定めておくことで、誰でも同じ方法で名前付けできるため、可読性、一貫性、生産性を向上させる上で重要。

## 複合語（○○ケース）
基本的に開発言語で規定されているので、代表例を列挙する程度にとどめる。

- 規約例
    - [TypeScript Deep Dive 日本語版](https://typescript-jp.gitbook.io/deep-dive/)
        - [TypeScript Deep Dive 日本語版 クラス名前空間](https://typescript-jp.gitbook.io/deep-dive/styleguide#ming-qian-kong-jian)
    - [python pep8-ja](https://pep8-ja.readthedocs.io/ja/latest/#)
        - [python pep8-ja 命名規約](https://pep8-ja.readthedocs.io/ja/latest/#section-20)

### スネークケース（英: snake_case）
- 利用例
    - python variable

### アッパースネークケース（英: UPPER_SNAKE_CASE）
- 利用例
    - python constant

### キャメルケース（英: camelCase）
- 利用例
    - javascript variable
- パスカルケースとの相互変換が楽
- 別名
    - ロウワーキャメルケース（英: lowerCamelCase）

### パスカルケース（英: PascalCase）
- 利用例
    - python class
    - javascript class
- キャメルケースとの相互変換が楽
- 別名
    - アッパーキャメルケース（英: UpperCamelCase）

### ケバブケース（英: kebab-case）
- 利用例
    - REST API URI 
        - よく使われているぐらいで規定ではない
        - [uriでの利用はGoogleが推奨](https://developers.google.com/search/docs/crawling-indexing/url-structure?hl=ja&visit_id=638208071760208548-2751827508&rd=1)
- 区切りの視認性が高い
- `-`が予約語の場合が多いので、プログラミング言語ではあまり使われない
- 別名
    - スパイナルケース（英: spinal-case）
    - チェインケース（英: chain-case）

### 備考：ケースセンシティブ（英: case-sensitive）
[ケースセンシティブ](https://ja.wikipedia.org/wiki/%E3%82%B1%E3%83%BC%E3%82%B9%E3%83%BB%E3%82%BB%E3%83%B3%E3%82%B7%E3%83%86%E3%82%A3%E3%83%96)は文字列の大文字と小文字を区別して扱うことを指す。逆に、大文字と小文字を区別しないことを、ケースインセンシティブ（英: case-insensitive）と呼ぶ。  
例えば、postgresqlはケースインセンシティブであるため、キャメルケースを命名規則として採用している。

## コレクション名（単数形と複数形）
コレクションにアクセスするような名前を決める際、単数形を採用するのか複数形を採用するのかは設計者の好みが出るところである（個人的には単数形派）。  
例えば、REST APIのリソース表現やDDLのテーブル名などが該当する。

### 全て単数形
- 概念にアクセスするという解釈のもと単数形とする
    - activity
- モデルについて単数形だけ覚えればよい
- 記述が一番シンプルになりやすい
- 設計指針などのコンテキストを見ないと概念なのかコレクションなのかドキュメント（コレクションに含まれる一つの実体）なのかどうかを判断できない

### 全て複数形
- ネイティブ的表現に寄せる
    - activities
- ネイティブから見ると慣習的と思われる
- 非ネイティブから見ると変化形も知ってなくてはならない

### 複数形の場合sやlistをサフィックスにする
- 非ネイティブでも簡易的に切り分けできる
    - activitys, activity-list
- ある種の割り切りなので、ネイティブから見ると不自然な表現になるかも

### 参考：単数形と複数形
- [5.1. テーブルの基本](https://www.postgresql.jp/docs/9.0/ddl-basics.html)
    - テーブル名に単数形あるいは複数形どちらの名詞を使用するかという選択肢があります（これは論者によって好みが分かれています）。
- [テーブルの名前って複数形？単数形？](https://qiita.com/siinai/items/d4274c95fcdde3fd7295)
    - あたしの判断としては、「テーブル名は単数形にするべき」、が現状の最適解
    - 複数形のメリットが「慣習」以上の解が見つけられない

## 省略記法
一部の名詞は省略記法が用いられる。  
一般的に広く使われる省略記法は取り入れてもよいと考える。  
なお、一般的ではない名詞は省略すると、意味がわからなくなる場合があるので、略記するかどうかは慎重に判断するのが望ましい。  
入力が大変であれば、基本的にはエディタの補完機能を使えるようにしたほうが良い。

### 省略手法
1. 頭文字語を使う（acronym）
    - pwd : Print Working Directory
2. ある子音より後を削る
    - app : application
3. 重要な文字だけを残す
    - btn : button
4. 2と3の合わせ技
    - jp : japan

### 良く省略表現されるもの

| 記述 | 非省略記述     | 意味               |
| ---- | -------------- | ------------------ |
| id   | identification | 身分証明、識別番号 |
| idx  | index          | 索引               |
| tmp  | temporary      | 一次的             |
| init | initialize     | 初期化する         |

### 参考：省略記法
- [変数名に使う英単語を省略するのための4方式](https://qiita.com/Yusuke196/items/b5e51ee6d77ca1b672c2)
- [プログラミング初心者は変数名やメソッド名を略さない方がいいよ、という話](https://blog.jnito.com/entry/2020/10/20/092724)

## その他参考
- [プログラミングの変数・メソッドの命名でよく使う英単語まとめ](https://arakan-pgm-ai.hatenablog.com/entry/2019/04/15/000000)