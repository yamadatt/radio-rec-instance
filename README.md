## このリポジトリは？

ラジオ録音用のEC2インスタンスを立ち上げるterraform。

## 背景

ラジコのタイムフリーに対応していない番組はリアルタイムに録音したい。

 EC2でサーバを構築すると言ってもインターネットで通信するには、VPC作って、サブネットに切って、インターネットGW作って、ルーティング入れて、セキュリティグループを適用する等、ブラウザを使って手動構築すると面倒。また、サーバを削除するにも複数のコンポーネントを削除しないと課金されてしまうのでそれらを気にするのが嫌だ。

そこで、素早くサーバを構築して、素早くサーバを削除することでec2に手間をかけずにラジオ録音できるようにする。

## このterraformでできること

このterraformでEC2インスタンス構築まで行う。

ミドルウエア等はこのリポジトリの[ansible](https://github.com/yamadatt/ansible-ec2)で構築する。

git,dockerをインストールして、タイムゾーンの変更で動くと思うので、頑張って手で構築すること。

## 使い方

構築時のコマンド

applyとdestroyは```-auto-approve```オプションをつけると便利。

    terraform init
    terraform plan
    terraform apply -auto-approve


環境の削除コマンド

    terraform destroy -auto-approve


## 環境

### 前提条件

awscliがインストールされていること

    aws --version
    aws-cli/2.17.44 Python/3.11.9 Linux/6.8.0-51-generic exe/x86_64.ubuntu.22

### 動作を確認したterraformのバージョン

以下のバージョンで動作確認している。

    terraform --version
    Terraform v1.9.8
    on linux_amd64

### キーペアの作成

キーペアは事前に作成しておく（作成しておかないとsshできない）

ここではradioという名前で作成している。

ダウンロードしたキーファイルは```chmod 600```しておく。
