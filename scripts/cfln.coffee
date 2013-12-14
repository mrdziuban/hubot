jsdom = require 'jsdom'

module.exports = (robot) ->
  robot.respond /commit( me)?/i, (msg) ->
    url = 'http://www.commitlogsfromlastnight.com/'
    msg.http(url).headers('User-Agent': 'hubot').get() (err, res, body) ->
      scrape msg, body, (commit) ->
        msg.send commit

scrape = (msg, body, cb) ->
  jsdom.env body, (errors, window) ->
    commits = []
    for commit in window.document.getElementsByClassName('commit')
      commits.push commit.textContent
    commitToPost = msg.random commits
    cb commitToPost
