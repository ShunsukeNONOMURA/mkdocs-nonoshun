# ハッシュ値の割り出し
Pythonでは下記の[hashlib](https://docs.python.org/ja/3/library/hashlib.html)を用いてhash値を求めることができる。

## サンプルコード
```python
import hashlib

def file_sha(file_path, size=32768):
    # ハッシュ計算のアルゴリズムを選択
    m = hashlib.sha1()
    # m = hashlib.sha256()
    # m = hashlib.sha512()
    with open(file_path, 'rb') as f:
        for chunk in iter(lambda: f.read(size * m.block_size), b''): # MemoryError回避として段階読み込み
            m.update(chunk)
            break # 全読みだと時間がかかるので先頭だけで計算を打ち切る場合
    return m.hexdigest()
```

- 先頭から少しずつ読み出す形だとメモリエラーを回避できる

## 参考
- [Pythonでファイルのハッシュ計算をする（ダイジェスト）](https://scrapbox.io/nwtgck/Python%E3%81%A7%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%81%AE%E3%83%8F%E3%83%83%E3%82%B7%E3%83%A5%E8%A8%88%E7%AE%97%E3%82%92%E3%81%99%E3%82%8B%EF%BC%88%E3%83%80%E3%82%A4%E3%82%B8%E3%82%A7%E3%82%B9%E3%83%88%EF%BC%89)