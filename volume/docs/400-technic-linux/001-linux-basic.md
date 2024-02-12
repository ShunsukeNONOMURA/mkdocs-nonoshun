# linux利用メモ

## chown
所有者変更

```
sudo chown -R {user}:{group} {dir}
# sample
sudo chown -R testuser:testuser ./hoge/
```

### オプション
- -R
  - ディレクトリ内の所有者も再帰的に変更

## cp
ファイルをコピーする
```
# a以下の全てをb以下にコピー
cp -R a/. b/.
```

### オプション
- -p
  - パーミッションもコピー
- -R
  - 再帰的にコピー
  - -rは非推奨なので気をつける

## echo
画面に文字列を表示
```
# abcと表示
echo abc
# 変数を表示
a=10
echo $a
# コマンド結果を表示
echo $(date)
# コマンド結果を log.txtに出力
echo $(date) > log.txt
echo $(date +\%Y\%m\%d\%H\%M\%S) > log.txt
```

## history
コマンド履歴を提示
```
# すべて表示
history
# abcが含まれるコマンドを表示
history \| grep abc
```

## tree
ディレクトリ一覧

```
# ない場合インストール
sudo apt install tree
# 階層表示
tree {root_path}
# 隠しファイル含めて
tree -a {root_path}
```

## kill
プロセスの停止  
画面がフリーズしているときはCLI画面に Ctrl+Alt+F3 などで移動してから実行する

```
# 特定のプロセス(chrome)をすべて停止
pkill -f chrome

# vlcに関するプロセスを表示
ps -ef | grep vlc

# 強制停止
kill -9 PID
```

## shutdown
```
shutdown -h 分
shutdown -h 1

shutdown -r now # 再起動

shutdown -c # キャンセル
```


## その他

| 記号 | 意味 |
| - | - |
| A \| B | パイプ　history \| grep abc |
| A > B | リダイレクト　Aの出力先をBにする |
| A ; B | Aの終了後、Bを実行 |
| A & B | Aの終了を待たず、直ちにBを実行 |
| A && B | Aが正常終了（終了コードが0）した場合、Bを実行 |
| A \|\| B | Aが異常終了（終了コード0以外）した場合、Bを実行 |
