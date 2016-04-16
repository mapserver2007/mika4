# mika4
## インストール
以下のものをインストール。
* `node.js`,`npm`,`nvm`

以下のコマンドを実行

```sh
$> npm install -g hubot coffee-script generator-hubot
$> mkdir bin
$> cd bin
$> yo mika4
```

アダプターは`slack`を指定する。

## ローカル実行
OSX

```sh
$> brew install redis
$> redis-server /usr/local/etc/redis.conf
$> bin/hubot --name mika4
```

## Slack設定
* アカウントおよびルームを作成する
* [https://slack.com/apps](Browse Apps) > Hubot > Configurations on [your-team] > Edit configuration
* APIキーを取得する
* 秘密情報は`config/hubot.secret.yml`に記述する

## Herokuデプロイ
```sh
$> heroku login
$> heroku create
$> rake heroku_env
$> rake
```

プラグインは以下のものを入れる。
* Process Scheduler
    * 8:00-2:00
* Heroku Scheduler
    * hubot-heroku-keepaliveを指定時間に起動するためのスケジューラ
    * curl ${HUBOT_HEROKU_KEEPALIVE_URL}heroku/keepalive
    * UTCなので開始時間の9時間前を指定。開始時間は8:00なので23:00を指定
* PaperTrail
    * heroku drains:add syslog+tls://logs.papertrailapp.com:12345 --app mika4
    * アドレスは実際のものを指定

## License
Licensed under the MIT  
http://www.opensource.org/licenses/mit-license.php
