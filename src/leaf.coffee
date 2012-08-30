#= require underscore
#= require linked_list

class TandemLeaf extends LinkedList.Node
  @groupByLine: (leaves) ->
    return _.reduce(leaves, (lines, leaf) ->
      if !lines[leaf.line.id]?
        lines[leaf.line.id] = []
      lines[leaf.line.id].push(leaf)
    , {})

  @isLeafNode: (node) ->
    return node.childNodes.length == 1 && node.firstChild.nodeType == node.TEXT_NODE || node.tagName == 'BR'


  constructor: (@line, @node, @attributes) ->
    @text = @node.textContent
    @length = @text.length

  setText: (@text) ->
    @node.textContent = @text
    @length = @text.length
    @line.resetContent()


class TandemLeafIterator
  # Start and end are both inclusive
  # Otherwise if end is inclusive, we cannot express end of line unambiguously
  constructor: (@start, @end) ->
    @cur = @start

  next: -> 
    ret = @cur
    if @cur == @end || @cur == null
      @cur = null
    else if @cur.next?
      @cur = @cur.next
    else
      line = @cur.line
      while line? && line.leaves.length == 0
        line = line.next
      @cur = if line? then line.leaves.first else null
    return ret

  toArray: ->
    arr = []
    itr = new TandemLeafIterator(@start, @end)
    while next = itr.next()
      arr.push(next)
    return arr

window.Tandem ||= {}
window.Tandem.Leaf = TandemLeaf
window.Tandem.LeafIterator = TandemLeafIterator