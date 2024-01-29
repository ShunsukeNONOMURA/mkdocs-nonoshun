# Webスクレイピング
Pythonでは下記の2つのライブラリを用いてWebスクレイピングすることができる。

- [requests](https://pypi.org/project/requests/)でHTMLダウンロード
- [BeautifulSoup4](https://pypi.org/project/beautifulsoup4/)でデータ解析

## BeautifulSoup4
- python製のパーサーで標準ではhtmlに対応している
- 拡張だとlxmlやhtml5にも対応している
- select系とfind系のメソッドがあり、好みで使い分ける

## 大まかな利用手順
0. 元データ確保
1. BeautifulSoup4.soup作成
2. 全体表示して読み込み確認と構造把握
3. select等のメソッドを利用して必要なデータにパースする
4. パースしたデータをもとに処理を実行

### サンプルコード
```python
import urllib.error
import urllib.request

import requests
from bs4 import BeautifulSoup

from pprint import pprint

# 0. 元データ確保
## requestsで取得する例
url = "https://pystyle.info/apps/scraping/"
res = requests.get(url)
if not res.ok:
    print(f"ページの取得に失敗しました。status: {res.status_code}, reason: {res.reason}")
else:
    html_doc = res.content

## 今回はサンプルとして下記のようなhtmlテキストが得られたものとする
html_doc = """
<html>
<head>
    <title>ニュース</title>
</head>
<body>
    <h1>ニュース</h1>

    <div class="topic">
        <h2>トピック一覧</h2>
        <ul class="list" id="menu">
            <li>トピック1</li>
            <li>トピック2</li>
        </ul>
    </div>

    <div class="images">
        <h2>注目の画像</h2>
        <ul class="list">
            <li><img src="https://www.python.org/static/img/python-logo.png" alt="画像1"></li>
            <li><img src="https://www.python.org/static/img/python-logo.png" alt="画像2"></li>
        </ul>
    </div>

    <p>お気に入りに<a href="sample.com">このサイト</a>を登録してください。</p>
</body>
</html>
"""

# 1. BeautifulSoup4.soup作成（htmlパーサー使用）
soup = BeautifulSoup(html_doc, "html.parser")

# 2. 全体表示して読み込み確認と構造把握
print("soup.prettify()")
print(soup.prettify()) # 全体表示
print('\n')

# 3. select等のメソッドを利用して必要なデータにパースする
print("soup.select_one('#menu').select('li')")
pprint(soup.select_one("#menu").select('li')) # id="menu" のタグを見つけて、その中のliタグをすべて見つける
print('\n')

print("soup.select_one('div.images').select('.list')")
pprint(soup.select_one('div.images').select('.list')) # class="image" のdivタグを一つ見つけて、その中のclass="image"をすべて見つける
print('\n')

print("[tag['src'] for tag in soup.select('img')]")
pprint([tag['src'] for tag in soup.select('img')]) # imgタグをすべて見つけて、その中のsrc属性を取り出してリスト化する
print('\n')

# 4. パースしたデータをもとに処理を実行（srcのダウンロード）
print("donwload : [tag['src'] for tag in soup.select('img')]")
for i, url in enumerate([tag['src'] for tag in soup.select('img')]):
    print(url)
    dst_file_path = f"{i}.{url.split('.')[-1]}"
    try:
        with urllib.request.urlopen(url) as web_file:
            data = web_file.read()
            with open(dst_file_path, mode='wb') as local_file:
                local_file.write(data)
    except urllib.error.URLError as e:
        print(e)
        raise Exception
```

## 補足：id属性/class属性の違い
- idはページ内で一度だけ使用。主にJavaScriptで要素を操作する際やアンカーリンクの作成に利用。
- classは複数の要素に同じclass名を設定。主にCSSでスタイルを適用する際に利用。

## 参考
- [WebスクレイピングのためのCSSセレクタの基本](https://gammasoft.jp/support/css-selector-for-python-web-scraping/)
- [Beautiful Soup のfind_all( ) と select( ) の使い方の違い](https://gammasoft.jp/blog/difference-find-and-select-in-beautiful-soup-of-python/)
- [【HTML】id属性/class属性の違い・使い分けを３分でわかりやすく解説](https://it-biz.online/web-design/id-class/)

## 課題メモ
- `print(soup.prettify())`だと階層構造がわかりにくいので見やすくしたい