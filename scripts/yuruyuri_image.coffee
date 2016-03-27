# Description:
#   Get lovelive animation gif from tumblr
# Commands:
#   mika4
tumblr = require "tumblrbot"

module.exports = (robot) ->
  robot.respond /(?:(.+)画像)はよ((?:\uFF01|!){0,})/i, (msg) ->
    maxCount = 4
    count = 1
    if msg.match[2]
      if msg.match[2].length <= maxCount
        count = msg.match[2].length
      else
        count = maxCount
    limitMaxCount = 30
    limitCount = 1
    url = "https://api.mlab.com/api/1/databases/#{process.env.database}/collections/#{process.env.collection_tumblr_config}?apiKey=#{process.env.apikey}"

    getConfig = (callback) ->
      msg.http(url)
        .get() (err, res, body) ->
          callback JSON.parse(body)

    getIndex = (list) ->
      parseInt Math.random() * list.length - 1, 10

    getImage = (config, imgNum) ->
      console.log "imgNum:" + imgNum
      console.log "limitCount:" + limitCount
      return if imgNum > count || limitCount > limitMaxCount
      id = config.id[getIndex config.id]
      tag = config.tag[getIndex config.tag]
      tumblr.photos(id + ".tumblr.com").random { tag: tag }, (post) ->
        if post
          msg.send post.photos[0].original_size.url
          imgNum++
        limitCount++
        getImage config, imgNum

    getConfig((configList) ->
      for config in configList
        if config.keyword == msg.match[1]
          getImage config, 1
    )
