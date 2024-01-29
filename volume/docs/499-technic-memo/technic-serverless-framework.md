# Serverless Framework

Serverless Framework（以下sls）とは

cfnで頑張ればかけるだろうが、楽したい。

![](https://storage.googleapis.com/zenn-user-upload/a7ce83018b4f-20230620.png)

## 類似ライブラリ
今回はslsの利用を試す意味合いが強いので他のツールについては掘り下げない。

- Webアプリを爆速で作りたい時
    - AWS Amplify
- サーバレスアプリをいい感じに作りたい時
    - Serverless Framework
- サーバレスアプリを作りたい時でAWS公式ツールが良い時
    - AWS SAM
- AWS環境にスタンダードなインフラ構築をする時
    - AWS CDK
- [API Gateway + LambdaをいろいろなIaCツールで構築したので比較する](https://zenn.dev/ncdc/articles/ebbeb4cecaa838)

## slsが作るリソース


## 導入

```

```

aws cliを利用するときのように認証情報を設定する必要がある。  
下記のような環境変数を設定しておくのが簡易的。  

```

```

### Python環境での構築
FastAPIやDjangoを

serverless-python-requirementsは多分内部的にpip freezeのようなことをしている感じがする。

[Mangum](https://mangum.io/)
[serverless-python-requirements](https://github.com/serverless/serverless-python-requirements)

[筆者のfastapi構築例](https://github.com/ShunsukeNONOMURA/python-fastapi-master)

## 作成例
```

```

## 構成の設定
利用するインフラ制約によってはslsで作成するリソースについてAWS ConfigやService Control Policyに適わない場合がある。

### S3暗号化に関するパラメータがうまく機能しない
provider.deploymentBucket以下で暗号化に関するパラメータがあるが、うまく機能しない模様。s3を別途用意して名前指定して紐づけることで回避する。


暗号化に関する設定。うまく機能しなかった。    
[リファレンス](https://www.serverless.com/framework/docs/providers/aws/guide/serverless.yml)  
```
provider:
  deploymentBucket:
    serverSideEncryption: aws:kms
    sseKMSKeyId: arn:aws:kms:ap-northeast-1:xxxxxxxx:key/xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx
```

[AWS仕様に追従できていないバグらしい](https://github.com/serverless/serverless/issues/11749)  

予め作成しているs3を指定するとうまく機能した。  
[Serverless Frameworkのデプロイ用S3バケットの設定](https://suzuki-navi.hatenablog.com/entry/2021/01/08/142206)
```
provider:
  deploymentBucket:
    name: bucket-name
```