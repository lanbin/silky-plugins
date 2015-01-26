#    Author: 易晓峰
#    E-mail: wvv8oo@gmail.com
#    Date: 1/26/15 11:29 AM
#    Description:

_autoprefixer = require 'autoprefixer-core'
_fs = require 'fs-extra'

#标识这是一个silky插件
exports.silkyPlugin = true
#提供注册插件的入口
exports.registerPlugin = (silky)->
  autoprefixHandler = (options, content)->
    _autoprefixer(options || {}).process(content).css

  #处理css的前缀问题
  silky.registerHook 'route:willResponse', {}, (data, options, done)->
    return if not /\.css$/.test data.request.url
    data.content = autoprefixHandler options, data.content
    return

  #编译后，处理前缀
  silky.registerHook 'build:didCompile', {async: true}, (data, options, done)->
    return done null if not /\.css$/.test data.target
    content = _fs.readFileSync data.target, 'utf-8'

    content = autoprefixHandler options, content
    _fs.outputFileSync data.target, content
    done null

