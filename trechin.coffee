# Description:
#   Train delay notify by trechin-bot
# Commands:
#   mika4 [東上線]遅れてる？
#   mika4 [埼京線]遅延
#   mika4 [有楽町線]おわた

httpClient = require "scoped-http-client"

module.exports = (robot) ->
  robot.respond /(.+?線)([あ-んが-ぼぁ-ょゎっー]?)(遅れ|遅延|死|生|おわた)/i, (msg) ->
    trainName = msg.match[1]
    getTrainState = (query, callback) ->
      url = "http://trechin-web.herokuapp.com/search/" + encodeURIComponent(query)
      httpClient.create(url)
        .header('User-Agent', 'mika4')
        .get() (err, res, body) ->
          callback(JSON.parse(body))

    getTrainState(trainName, (json) ->
      if (json.hasOwnProperty("name"))
        if json["detail"] == ""
          msg.send "#{json['name']}は#{json['state']}みたいだよぉ(＊´ω｀＊)"
        else
          msg.send "#{json['name']}は#{json['state']}だって！ありえないっしょ！"
          setTimeout ->
            msg.send "『#{json['detail']}』(●｀ε ´●)"
          , 2000
      else
        msg.send "しらない路線だよぉ(>_<)"
    )
