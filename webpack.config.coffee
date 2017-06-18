
###
  A generic webpack for building React components written in coffeescript and CJSX

  jquery, react, react-dom, backbond and underscore are all external (not bundled)

  See also, https://github.com/felixhao28/using-coffee-react-for-frontend-dev-walkthrough
###
fs = require('fs-extra')
_ = require('lodash')

Path = require("path")
Glob = require("glob")
Webpack = require("webpack")
Inflection = require('inflection')


# assume run from project root this the user of this package's package
userPackage = JSON.parse(fs.readFileSync('package.json'))


module.exports = 
  cache: true
  entry: [
    # "webpack-dev-server/client?http://localhost:3000", # WebpackDevServer host and port
    # "webpack/hot/only-dev-server",
    "./#{userPackage.main}" # Main app"s entry point according to package.json
  ],
  output:
    path: "dist/"
    filename: "#{userPackage.name}.js"
    libraryTarget: "umd"
    library: Inflection.camelize(userPackage.name.replace(/[ \-]/g, "_"), false)
    publicPath: "dist/"
    
  debug: true,

  externals: 
    'jquery': {
      root: 'jQuery'
      commonjs2: 'jquery',
      commonjs: 'jquery',
      amd: 'jquery'
    }
    'react': {
      root: 'React',
      commonjs2: 'react',
      commonjs: 'react',
      amd: 'react'
    }
    'react-dom': {
      root: 'ReactDOM',
      commonjs2: 'react-dom',
      commonjs: 'react-dom',
      amd: 'react-dom'
    }
    'backbone': {
      root: "Backbone"
      commonjs2: 'backbone'
      commonjs: 'backbone'
      amd: 'backbone'
    }
    'underscore': {
      root: "_"
      commonjs2: 'underscore'
      commonjs: 'underscore'
      amd: 'underscore'
    }
    

  resolve:
    extensions: ["", ".jsx", ".cjsx", ".coffee", ".js"]
    modulesDirectories: ["src", "node_modules"]

  module:
    loaders: [
      # 
      # DON'T WEBPACK CSS.  if you do a require(`../css/someFile.css`) that file will fail to load in tests
      # If you need to include CSS for a component of this lib:
      #   - keep it minimal (let our users style and format)
      #   - please don't use inline styles as they are difficult for our user to override
      #   - put the css in a file that is of same or similar name to the components in the css/ dir
      #
      #   test: /\.css$/                         # required to write "require("./someFile.css")"
      #   loader: "style-loader!css-loader"
      # ,
      
      # required for bootstrap icons
      test: /\.(woff|woff2)$/
      loader: "url-loader?prefix=font/&limit=5000&mimetype=application/font-woff"
    ,
      test: /\.ttf$/
      loader: "file-loader?prefix=font/"
    ,
      test: /\.eot$/
      loader: "file-loader?prefix=font/"
    ,
      test: /\.svg$/
      loader: "file-loader?prefix=font/"
    ,
      test: require.resolve("jquery")
      loader: "expose?$"
    ,
      test: require.resolve("jquery")
      loader: "expose?jQuery"
    ,
    #   test: require.resolve("react")
    #   loader: "expose?React"
    # ,
    #   test: /\.jsx$/
    #   loaders: ["react-hot", "jsx-loader?insertPragma=React.DOM"]
    #   include: Path.join(__dirname, "src")
    # ,
      test: /\.cjsx$/
      loaders: ['coffee', 'cjsx']
    ,
      test: /\.coffee$/ 
      loader: 'coffee-loader' 
    ,
      test: /\.jsx?$/,
      loader: 'babel-loader',
    ,
      test: /\.(png|jpg|gif)$/
      loader: 'url-loader?limit=8192' # inline base64 URLs for <=8k images, direct URLs for the rest
      #test: /\.jpe?g$|\.gif$|\.png|\.ico$/, loader: 'file' 
    ,
      test: /\.json$/
      loader: 'json'
    ]      
      
  plugins: [
    # #  this adds a lot of code to the bundle for hot loading feature
    # new Webpack.HotModuleReplacementPlugin()


    ## I think this and changing the debug setting above to `debug: false` above are all that
    ##   should be needed to produce an optimized minified package
    # new Webpack.optimize.DedupePlugin(),
    # new Webpack.optimize.UglifyJsPlugin
    #  compress:
    #    warnings: false
    #  mangle:
    #    except: ['$super', '$', 'exports', 'require']
  ]


