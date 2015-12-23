#!/usr/bin/env coffee

fs = require('fs-extra')
Path = require('path')

absoluteParentDir = Path.resolve(Path.join(process.cwd(), '..'))

for dir in ['bumble-build', 'bumble-docs', 'bumble-test']
  linkSrcDir = Path.join(absoluteParentDir, dir)
  linkTarget = Path.join('.', 'node_modules', dir)
  fs.removeSync(linkTarget)
  fs.ensureSymlinkSync(linkSrcDir, linkTarget)
