# Description:
#   Execute heroku command operation script.
# Commands:
#   mika4 (app name)再起動
#   mika4 (app name)を起動
#   mika4 (app name)が停止

async = require "async"
nodemailer = require "nodemailer"
smtpTransport = require "nodemailer-smtp-transport"

module.exports = (robot) ->
  robot.respond /([a-zA-Z0-9_-]+)([の|を|が]{0,1})(再起動|起動|停止)/i, (msg) ->
    command = ""
    switch (msg.match[3])
      when "起動"
        command = "start"
      when "停止"
        command = "stop"
      when "再起動"
        command = "restart"

    smpt = nodemailer.createTransport smtpTransport
      service: process.env.MAIL_SERVICE
      auth:
        user: process.env.MAIL_ADDRESS
        pass: process.env.MAIL_PASSWORD

    mail =
      to: process.env.MAIL_ADDRESS
      subject: "#{msg.match[1]} #{command}"
      text: "mika4"

    url = "https://api.mlab.com/api/1/databases/#{process.env.database}/collections/#{process.env.collection}?apiKey=#{process.env.apikey}"

    count = 0
    retryCount = 5
    getTask = (callback) ->
      msg.http(url)
        .get() (err, res, body) ->
          data = JSON.parse(body)
          if data.length == 0
            if ++count < retryCount
              msg.send "ちょっとまってね〜"
              callback(true)
            else
              msg.send "#{msg.match[3]}失敗しちゃったかも"
          else
            callback(false, data[0])

    initTask = (callback) ->
      msg.http(url)
        .header('Content-Type', 'application/json')
        .put("[]") (error) ->
          if error
            msg.send "エラーになっちゃったよぉ"
            msg.send "『#{error}』"
          else
            callback()

    initTask ->
      smpt.sendMail mail, (error, response) ->
        if error
          msg.send "メール送れなかったよぉ"
        else
          msg.send "#{msg.match[1]}を#{msg.match[3]}するよぉ(｀・ω・´)"
          async.retry {times: retryCount, interval: 10000}, getTask, (isError, data) ->
            if isError == false
              switch data.status
                when 0
                  msg.send "#{msg.match[3]}終わったよぉ(＊´ω｀＊)"
                else
                  msg.send "エラーになっちゃったよぉ"
                  msg.send "『#{data.message}』"
        smpt.close()
