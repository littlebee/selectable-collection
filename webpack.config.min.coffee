
###
  optimized config.  see ./webpack.config.coffee
###

fs = require('fs')
_ = require('lodash')
Webpack = require("webpack")
Path = require("path")

baseConfig = require('./webpack.config')

# assume run from project root this the user of this package's package
userPackage = JSON.parse(fs.readFileSync('package.json'))

optimizedConfig =
  debug: false,
  output:
    filename: "#{userPackage.name}.min.js"
  plugins: baseConfig.plugins.concat [
    new Webpack.optimize.DedupePlugin(),
    new Webpack.optimize.UglifyJsPlugin(
      compress:
        warnings: false
      mangle:
        except: ['$super', '$', 'exports', 'require']
    )
  ]

exportConfig = _.defaultsDeep optimizedConfig, baseConfig

#console.log exportConfig
module.exports = exportConfig
