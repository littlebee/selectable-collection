###

  Originally installed by node_modules/.bin/bumble-build.
  
  You can reset to base config at anytime by running 
  node_modules/.bin/bumble-build. 
  
  BE SURE TO CHECK in your changes before resetting

  webpack setup and external grunt tasks borrowed from:
    https://github.com/felixhao28/using-coffee-react-for-frontend-dev-walkthrough

###

Path = require('path')
_ = require('lodash')

CSS_FILES_TO_DISTRIB = [
  'css/**/*.css'
]


BUMBLE_DOCS_SCRIPTS = './node_modules/bumble-docs/bin/'
bumbleScriptCommand = (scriptFile, args="")-> 
  return "coffee #{Path.join(BUMBLE_DOCS_SCRIPTS, scriptFile)} #{args}"


module.exports = (grunt) ->
    
  # load plugins
  # this loads all of the grunt-... packages in package.json.  clever
  require('load-grunt-tasks')(grunt)
  pkg = grunt.file.readJSON("package.json")

  # initialize grunt
  grunt.initConfig
  
    pkg: pkg

    # args to initConfig method are the tasks
    clean:
      distrib: ["dist/#{pkg.name}.*"]
      
    cjsx:
      build:
        files: [
          expand: true
          cwd: 'src'
          src: ['**/*.cjsx', '**/*.coffee']
          dest: 'lib'
          ext: '.js'
        ]
              
    cssmin:
      options:
        shorthandCompacting: false,
        keepBreaks: true
      distrib:
        files:[
          {src: CSS_FILES_TO_DISTRIB, dest: "dist/#{pkg.name}.css"}
        ]    
    
    shell:
      buildExamples:
        command: bumbleScriptCommand('buildExamples.coffee')

      buildDocIndex:
        command: bumbleScriptCommand('buildDocIndex.coffee')
        
      buildApiDocs: 
        command: bumbleScriptCommand('buildApiDocs.coffee')
      
      deploy:
        options:
          # should gracefully fail if it doesn't find zukeeper src.  see comment at top of the script
          failOnError: false
        command: 'coffee ./scripts/deploy.coffee'
      
      npmInstall:
        command: 'npm install'
      
      test:
        command: 'node_modules/bumble-test/bin/testRunner.coffee'
        execOptions:
          env: {NODE_ENV: 'test'}
        
      coverage:
        command: 'node_modules/.bin/istanbul report text-summary lcov'
    
    coveralls:
      options:
        force: true
      
      upload:
        src: 'coverage/lcov.info'
        

    availabletasks:
      tasks:
        options:
          filter: 'include'
          tasks: ['build', 'test', 'watch',  'clean', 'docs']
          descriptions: 
            build: "Builds everything except docs & examples"
            test: "Builds everything and then run tests in /test"
            watch: "Watch for changing files and calls build."
            docs: "Build the docs. To publish to github.io, you must pull master into gh-pages and run 'grunt build docs' in the gh-pages branch"
            clean: "Remove all compiled files. Use `grunt clean build` to rebuild everything from scratch"


    watch:
      build:
        files: ["src/**/*", "css/**/*", "lib/**/*", "scripts/**/*", "webpack.config.coffee"]
        tasks: ["build"]


    webpack:
      distrib: require("./webpack.config.coffee")
      optimize: require("./webpack.config.min.coffee")


  # tasks
  grunt.registerTask 'test', ["shell:test", "shell:coverage"]
  grunt.registerTask 'distrib', ['cssmin:distrib', 'webpack:distrib', 'webpack:optimize','shell:deploy']
  grunt.registerTask 'docs',  ['shell:buildDocIndex', 'shell:buildApiDocs', 'shell:buildExamples']
  grunt.registerTask 'build', ['shell:npmInstall', 'newer:cjsx:build', 'distrib']
  grunt.registerTask 'default', ['availabletasks']
