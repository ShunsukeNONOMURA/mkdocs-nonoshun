# Visual Studio Code メモ

## プラグイン
VSCode上で追加すると便利なプラグインについてまとめる

### Remote - SSH
[Remote - SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)

SSH接続ができる。

`C:\Users\USERNAME.ssh\config`等のconfigを編集して接続設定する。

設定例
```
Host openSUSE
    HostName 10.1.1.1
    User lab
    port 22
    IdentityFile C:\Users\USERNAME\.ssh\labkey
```

#### Could not establish connection to “127.0.0.1”: Remote host key has changed, port forwarding is disabled.
繋がらない場合は`~/.ssh/known_hosts`を削除する。

[VSCode の Remote-SSH でホストキーの変更によるポート転送の無効を解決する方法](https://webgroove.work/vscode-remote-ssh-localhost-can-not-connect/)

### Markdown Preview Enhanced
[Markdown Preview Enhanced](https://shd101wyy.github.io/markdown-preview-enhanced/#/)

高機能なMDビューア
右上の虫眼鏡付きの画面分割マークを押すかCtrl-K, Vで利用できる。

#### 参考
- [Visual Studio Code + Markdown Preview Enhancedはチームでデファクト化したいMarkdown環境だ！、と思う(2017/10月時点)](https://qiita.com/kitfactory/items/2fde799fa092f0d8f0f1)


### Draw.io Integration
[Draw.io Integration](https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio)


.dio.png形式のような[Draw.io](https://www.drawio.com/)用途ファイルをvscode上で利用できる。


### Edit csv
[Edit csv](https://marketplace.visualstudio.com/items?itemName=janisdd.vscode-edit-csv)
CSVのエディタ


<!-- ----------------- -->

## 整理中
Vue Language Features (Volar)


# setting
## 非表示
- [https://www.sukerou.com/2019/03/vs-codepythonpyc.html](https://www.sukerou.com/2019/03/vs-codepythonpyc.html)
- [Hiding Pycache Files in VS Code](https://paulnelson.ca/posts/hiding-pycache-files-in-vscode)

## windows
[Windowsの右クリックメニューに「VSCodeで開く」を追加する](https://qiita.com/kaityo256/items/7fefd1d1463184ae1420)

[SSHで『Host key verification failed』と出てログインできない時の対処法](https://note.affi-sapo-sv.com/ssh-verification-failed.php)

## プラグインめも
- docstring python docstring generator
- cloudformation linter
- intelicode
- markdownlint
- path inteliense
- テキスト構成くん

