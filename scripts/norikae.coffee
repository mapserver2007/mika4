# Description:
#   Search for train transfer
# Commands:
#   mika4 新宿→東京

moment = require "moment"

module.exports = (robot) ->
  robot.respond /(.+)→(.+)/i, (msg) ->
    url = "http://www.jorudan.co.jp/norikae/cgi/nori.cgi?Sok=1&eki1=#{msg.match[1]}&eki2=#{msg.match[2]}&type=t&Cway=0"
    msg.http(url).get() (err, res, body) ->
      msg.send "乗り換えしらべるよぉ"
      if /(■[\s\S]*?■.+)/.test(body)
        text = RegExp.$1
        msg.send text
        if /(\d{2}:\d{2})/.test(text)
          limitTime = new moment(RegExp.$1, "HH:mm").diff(new moment(), "minutes") + 1
          msg.send "あと#{limitTime}分だよぉ！=͟͟͞͞( ・∀・)"
      else
        msg.send "わからない経路だよぉ(>_<)"
