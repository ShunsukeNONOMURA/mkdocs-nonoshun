# Pythonメモ

## pathlib
```
```

## datetime
```
from datetime import datetime
from zoneinfo import ZoneInfo

datetime.now()
datetime.now(timezone.utc)
datetime.now(ZoneInfo("Asia/Tokyo"))

datetime.now().isoformat()
```

## yaml
```

```

sample.yml
```yaml
a: a
b:
  - b11: b11
    b12: 
      - b121: b121
  - b21: b21
    b22: b22
```

出力
```
```

## shutil
```
import os
import shutil
# ディレクトリを中身のファイルごと削除
if os.path.isdir("target_dir/") == True:
	shutil.rmtree("target_dir/")
```

## open
```
```

## sqlalchemy
### 削除
[SQLAlchemy で Delete するには？](https://qiita.com/nskydiving/items/eedd5cea88b5afdbfc49)


```python
# 一つ削除
session.query(Student).filter(Student.id==2).delete()
# in句で削除（fetchが必要）
session.query(Student).filter(Student.id.in_([3, 4])).delete(synchronize_session='fetch')
```

`sqlalchemy.exc.InvalidRequestError: Could not evaluate current criteria in Python. Specify 'fetch' or False for the synchronize_session parameter.`

## steamlit
- 簡単にwebアプリが作れる
- 状態管理に癖がある（1インタラクションごとに全て再実行）。

[Python だけで作る Web アプリケーション(フロントエンド編)](https://zenn.dev/alivelimb/books/python-web-frontend/viewer/about)