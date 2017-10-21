class Type
  main : ''
  nest_list : []
  field_hash: {}
  constructor:(str)->
    if !str
      @nest_list  = []
      @field_hash = {}
    else
      {ret, tail} = @_parse_tail str
      if tail
        throw new Error "invalid format. Unparsed tail '#{tail}'"
      @main       = ret.main
      @nest_list  = ret.nest_list
      @field_hash = ret.field_hash
  
  toString : ()->
    ret = @main
    if @nest_list.length
      jl = []
      for v in @nest_list
        jl.push v.toString()
      ret += "<#{jl.join ', '}>"
    
    jl = []
    for k,v of @field_hash
      jl.push "#{k}: #{v.toString()}"
    if jl.length
      ret += "{#{jl.join ', '}}"
    
    ret
  
  _parse_tail : (tail)->
    while tail[0] == " "
      tail = tail.substr 1
    full_ret = new Type
    if !reg_ret = /^([^{}<>,]+)(.*)$/.exec tail
      throw new Error "invalid format. Type identifier expected '#{tail}'"
    [_skip, main, tail] = reg_ret
    full_ret.main = main
    
    if tail[0] == "<"
      tail = tail.substr 1
      while tail[0] != '>'
        if tail == ""
          throw new Error "invalid format. Unexpected end of <> group '#{tail}'"
        {ret, tail} = @_parse_tail tail
        full_ret.nest_list.push ret
        [_skip, tail] = /^(?:\s*(?:,\s*)?)(.*)$/.exec tail
      tail = tail.substr 1
    
    if tail[0] == "{"
      tail = tail.substr 1
      while tail[0] != '}'
        if tail == ""
          throw new Error "invalid format. Unexpected end of {} group '#{tail}'"
        if !reg_ret = /^([^:]+):(.*)$/.exec tail
          throw new Error "invalid format '#{tail}' missing : in {} group '#{tail}'"
        [_skip, key, tail] = reg_ret
        {ret, tail} = @_parse_tail tail
        full_ret.field_hash[key] = ret
        
        [_skip, tail] = /^(?:\s*(?:,\s*)?)(.*)$/.exec tail
      tail = tail.substr 1
    
    {ret:full_ret, tail}

module.exports = Type