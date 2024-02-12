---
title: メタ設定
---

# メタ設定

メタ情報を付与して並び順を変えたり、タイトルを変更したりできる。

https://github.com/lukasgeiter/mkdocs-awesome-pages-plugin

## .pages
000-mkdocsディレクトリのメタ情報として.pagesを作成してタイトルなどを記述することができる。

```
./volume//docs
├── 000-mkdocs
│   ├── .pages
│   ├── mkdocs-meta.md
```

### .pagesの記述例
```
title : タイトル
order: desc
```

## .md内記述
markdownファイルの先頭に`---`で閉じた箇所を作りメタ情報を付与することができる。

```
---
title: タイトル
---

# title
```
