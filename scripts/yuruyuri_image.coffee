# Description:
#   Get lovelive animation gif from tumblr
# Commands:
#   mika4
tumblr = require "tumblrbot"
yaml = require "js-yaml"
fs = require "fs";

module.exports = (robot) ->
  robot.respond /(?:ゆりゆらー大歓喜画像|ゆるゆり画像|ごらく部画像)はよ/i, (msg) ->
    shuffle = (array) ->
      i = array.length
      if i is 0 then return false
      while --i
        j = Math.floor Math.random() * (i + 1)
        tmpi = array[i]
        tmpj = array[j]
        array[i] = tmpj
        array[j] = tmpi
      return

    file = fs.readFileSync 'config/tumblr.config.yml', 'utf8';
    config = yaml.safeLoad file
    index = parseInt Math.random() * config.tumblr.tag.length - 1, 10
    tag = config.tumblr.tag[index]
    shuffle config.tumblr.blog

    getImage = (tag, index) ->
      return unless config.tumblr.blog[index]
      tumblr.photos(config.tumblr.blog[index] + ".tumblr.com").random { tag: tag }, (post) ->
        unless post
          getImage tag, ++index
        else
          msg.send post.photos[0].original_size.url

    getImage tag, 0
