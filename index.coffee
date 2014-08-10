fs = require 'fs'
Path = require 'path'
glob = require 'glob'
_ = require 'underscore'
paths = process.argv.slice(2)
if paths.length == 0
  throw new Error('must specify at least one root source file to scan')
paths = paths.map(fs.realpathSync)
normalize = (path) ->
  try fs.realpathSync(path)
  catch e then null
queue = paths.slice(0)
enqueued = _.object([path, true] for path in paths)
path2deps = {}
while path = queue.pop()
  dir = Path.dirname(path)
  pattern = ///
    (?:^|\n)
    \S+
    [^\n]*
    require
    [^\w]+
    ['"]
    ( [\/\.\w-]+ )
    ['"]
  ///g
  contents = fs.readFileSync(path)
  matches = (match while match = pattern.exec(contents))
  odeps = ("#{dir}/#{match[1]}" for match in matches when _(match[1]).startsWith('.'))
  deps = (normalize("#{dep}.coffee") for dep in odeps when '.' not in Path.basename(dep))
  deps = deps.filter _.identity
  for dep in deps
    if dep not of enqueued
      enqueued[dep] = true
      queue.push(dep)
  path2deps[path] = deps
visiting = {}
chain = []
console.log path2deps
rec = (chain) ->
  node = _.last(chain)
  throw new Error("found cycle: #{chain.map(Path.basename)}") if visiting[node]?
  visiting[node] = true
  for next in path2deps[node] ? []
    rec(chain.concat([next]))
  delete visiting[node]
rec([paths[0]])
