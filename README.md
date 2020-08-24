## init

```
$ cp config.tf.sample config.tf
```


## 実行

common: リージョンごとのVPC、セキュリティグループ 
env: 各環境ごとのsubnet

より、

common => env
の順で実行するべし。

```
$ terraform init
($ terraform plan)
$ terraform apply
```


## 1-1.webコンソールでアクセスキー、シークレットキーありのユーザを作成。

環境変数で設定
```
$ export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
$ export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
$ export AWS_DEFAULT_REGION=ap-northeast-1
```

## 1-2.アクセスキーとシークレットキーを.aws/credentialsに保存。pipでawscliをインストール

.aws/credentials

```
aws_access_key_id = 控えたアクセスキー
aws_secret_access_key = 控えたシークレットアクセスキー
```

```
$pip install awscli
```

## 1-3.Dockerの場合


```
$ docker build -t terraform:latest .
$ docker run --it terraform bash
```

```
(# source ~/.bash_profile)
# tfenv install <version>
# cd <tfファイルのあるディレクトリ>
# terraform init
```

## 2-5 CircleCIのenvrionmentに設定
- AWS_ACCESS_KEY_ID: outputされたアクセスキー
- AWS_SECRET_ACCESS_KEY: outputされたシークレットキーを復号化したもの