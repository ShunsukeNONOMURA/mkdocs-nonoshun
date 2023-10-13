<!-- ubuntu22.04LTS -->
# Ubuntu22.04のセットアップ
## Ubuntu Install
1. UbuntuのISOを入手する
    - [Ubuntuを入手する](https://jp.ubuntu.com/download)
2. インストールメディアを作成する
    - アプリケーション一覧からディスクを検索して起動
    - ISOを書き込みたいUSBを選択して、メニューからディスクイメージをリストアを選択
    - [UbuntuでUSB起動メディアを作成する。](https://freefielder.jp/blog/2021/05/ubuntu-bootable-usb-flash.html)
3. usb bootでインストーラーを実行

## apt update
```
sudo apt update
sudo apt upgrade
```

## ホーム以下のディレクトリを英語に変更
```
LANG=C xdg-user-dirs-gtk-update
```
1. " Don't ask me this again " にチェック
2. [ Update Names ] をクリック

[Ubuntu でホームディレクトリ内のディレクトリ名を英語表記に](https://www.rough-and-cheap.jp/linux/ubuntu-change-xdg-directory-name/)

## SSH Install
```
# インストール
sudo apt update
sudo apt install openssh-server
# 確認
sudo systemctl status ssh
```
[Ubuntu 20.04 - SSHのインストールと接続方法](https://codechacha.com/ja/ubuntu-install-openssh/)

## XRDP Install
```
# インストール
sudo apt -y install xrdp
# 有効化
sudo systemctl enable xrdp
```
[デスクトップ環境 : Xrdp サーバーの設定](https://www.server-world.info/query?os=Ubuntu_22.04&p=desktop&f=7)

### xrdp で gedit起動できない場合の簡易対応
アクセス制御を無効化する
```
xhost +
```

### 「カラープロファイルを作成するには認証が必要です」を消す
```
# 残っていれば消す
sudo rm /etc/polkit-1/localauthority.conf.d/02-allow-colord.conf
sudo gedit /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
```

45-allow-colord.pklaの内容
```
[Allow Colord all Users]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
ResultAny=no
ResultInactive=no
ResultActive=yes
```
45-allow-colord.pklaを保存後に再起動
```
sudo systemctl restart polkit.service
```
[xrdpでリモートデスクトップしたときの「カラープロファイルを作成するには認証が必要です」を消す](https://tarufu.info/ubuntu_xrdp_color_profile/)

## GPU Software Install (NVIDIA)
NVIDIA GPUの場合の周辺ソフトウェアインストール
- [ubuntuにCUDA、nvidiaドライバをインストールするメモ](https://qiita.com/porizou1/items/74d8264d6381ee2941bd)
- [Ubuntu 22.04にNVIDIA Driverをインストール](https://hirooka.pro/nvidia-driver-ubuntu-22-04/)

### Nouveau の無効化
blacklist-nouveau.confを作成
```
sudo gedit /etc/modprobe.d/blacklist-nouveau.conf
```
以下の内容を保存
```
blacklist nouveau
options nouveau modeset=0
```
confファイルを保存後に実行
```
sudo update-initramfs -u
```

### NVIDIA Driver Install
```
# インストールするドライバを確認
ubuntu-drivers devices
# インストール
sudo ubuntu-drivers install # こっちだとうまく行かなかった

sudo apt install nvidia-driver-[version] -y
# 再起動して有効化
sudo reboot
# 動作確認
nvidia-smi
```

### Cuda Install
toolkit経由でのインストール
```
sudo apt install nvidia-cuda-toolkit
```

ubuntu22.04の場合
```
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.0.0/local_installers/cuda-repo-ubuntu2204-12-0-local_12.0.0-525.60.13-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2204-12-0-local_12.0.0-525.60.13-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-12-0-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda
```

~/.bashrcの末尾に以下を追加
```
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
```

バージョンの確認
```
nvcc -V
```

### cuDNN
[cuDNN Download](https://developer.nvidia.com/rdp/cudnn-download)
[【Ubuntu】NVIDIAドライバ・CUDA・CUDNNをインストールして深層学習環境を整える](https://guminote.sakura.ne.jp/archives/328#h2_7)

## Docker Install
```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh --dry-run
sudo usermod -aG docker ${USER}
```

**機能しない場合**
```
sudo apt-get update
sudo apt-get install \
  ca-certificates \
  curl \
  gnupg
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

**portainer sample**
```
version: '2'

services:
  portainer:
    restart: always
    image: portainer/portainer
    ports:
      - 9000:9000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```

### Temporary failure resolving ‘deb.debian.org’ の対応
[【Docker】イメージのビルド時にTemporary failure resolving ‘deb.debian.org’が発生する](https://public-constructor.com/docker-temporary-failure-resolving/)

DNSの設定を記述すると良いらしい

sudo gedit /etc/docker/daemon.json
```
{
  "dns": ["8.8.8.8", "8.8.4.4"]
}
```

docker再起動
```
sudo service docker restart
```

### Docker GPU
インストール
```
#!/bin/bash
# Reference sites
# https://github.com/NVIDIA/nvidia-docker/tree/master#quickstart
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#setting-up-nvidia-container-toolkit

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

動作確認
```
docker run --name nvidia-smi-sample --gpus all -it python:latest bash
nvidia-smi
exit
docker ps -a
docker rm [コンテナID]
```

動作確認（docker-compose.yml）
[参考：docker-compose で GPU を使う](https://kuttsun.blogspot.com/2021/11/docker-compose-gpu.html)
```yml
version: "3.0"
services:
  app:
    image: python:latest
    command: nvidia-smi
    tty: true
    deploy:
      resources:
          reservations:
              devices:
                  - capabilities: [gpu]
    environment: 
      - NVIDIA_VISIBLE_DEVICES=all
      - NVIDIA_DRIVER_CAPABILITIES=all
```


[Ubuntu 20.04へのDockerのインストールおよび使用方法](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04-ja)
[Install using the convenience script](https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script)
[Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
[Dockerイメージとコンテナの削除方法](https://qiita.com/tifa2chan/items/e9aa408244687a63a0ae)

## Git LFS
```
sudo apt install -y git-lfs
git lfs install
```

## Grub Customizer Install
```
sudo add-apt-repository ppa:danielrichter2007/grub-customizer
sudo apt-get update && sudo apt-get install grub-customizer
sudo grub-customizer
```

[Grub Customizer でブートローダーをGUI編集、デュアルブートを快適に。](https://thjap.org/linux/ubuntu/5962.html)


## Application Install
### Chrome Install
```
wget https://dl.google.com/linux/direct/google-chrome-stable_curre
nt_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb
```
[LinuxのターミナルからGoogle Chromeをインストールする方法](https://www.wikihow.jp/Linux%E3%81%AE%E3%82%BF%E3%83%BC%E3%83%9F%E3%83%8A%E3%83%AB%E[…]3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%99%E3%82%8B)

### VSCode
cli上でdebから直接インストールする場合
[Download Visual Studio Code](https://code.visualstudio.com/download)経由でdeb入手可能。
```
curl -L https://go.microsoft.com/fwlink/?LinkID=760868 -o vscode.deb
sudo apt install ./vscode.deb
rm vscode.deb
```
snap 経由だと日本語入力できない不具合があるので、避けるのが無難。
[UbuntuにVSCodeをインストールする3つの方法](https://qiita.com/yoshiyasu1111/items/e21a77ed68b52cb5f7c8#3-deb%E3%83%91%E3%83%83%E3%82%B1%E3%83%BC%E3%82%B8%E3%81%8B%E3%82%89%E7%9B%B4%E6%8E%A5%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB)

### slack
```
sudo snap install slack
```

### discord
```
wget "https://discord.com/api/download?platform=linux&format=deb" -O discord.deb
sudo apt install ./discord.deb -y
rm discord.deb
```
[2 Different Ways to Install Discord on Ubuntu 22.04](https://linuxhint.com/install-discord-ubuntu/)

### figma
```
sudo snap install figma-linux
```
[Install figma-linux on Ubuntu](https://snapcraft.io/install/figma-linux/ubuntu#install)

### draw.io
```
sudo snap install drawio
```
[Install draw.io on Ubuntu](https://snapcraft.io/install/drawio/ubuntu#install)

### 画像処理ツール
webp -> png -> pdf を実行するためのツール郡
```
sudo apt install webp
sudo apt install imagemagick
```

#### convertでのエラー対応
```
# メモリ不足
convert-im6.q16: cache resources exhausted
# 許可されていない形式
convert-im6.q16: attempt to perform an operation not allowed by the security policy
```

/etc/ImageMagick-6/policy.xml を編集
```
sudo gedit /etc/ImageMagick-6/policy.xml
```
**/etc/ImageMagick-6/policy.xml**
```
# メモリ上限を変更する
<policy domain="resource" name="memory" value="10GiB"/>
# PDFの利用制限を解除する
<!-- <policy domain="coder" rights="none" pattern="PDF" /> -->
```

- [Ubuntuで拡張子.webpの画像をPNGやJPGに一括変換する方法](https://minoru.okinawa/archives/2972)
- [画像とPDFを自由に加工できるimagemagickのconvertコマンドの使い方](https://virment.com/imagemagick-convert-pdf-image/)
- [ImageMagickのconvertコマンドで「cache resources exhausted」エラーの解消方法](https://blog.myanote.com/post/529)
- [ImageMagick で PS や PDF を扱えないわけは脆弱性対策でした](https://www.t3nro.net/posts/imagemagick-and-postscript-files/)


## メンテナンス
### User append
```
# 追加
sudo adduser USER_NAME
# 確認
cat /etc/passwd
# su権限付与
sudo usermod -aG sudo USER_NAME
```

### Spec参照
```
# OS
lsb_release -a
# kernel
uname -a
# CPU
sudo lshw -class processor
# GPU
lspci | grep -i nvidia
# マザーボード
sudo dmidecode -t baseboard
```