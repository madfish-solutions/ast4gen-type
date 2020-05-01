class Type
  main : ''
  nest_list : []
  field_map: {}
  constructor:(str)->
    if !str
      @nest_list  = []
      @field_map = {}
    else
      {ret, tail} = @_parse_tail str
      if tail
        throw new Error "invalid format. Unparsed tail '#{tail}'"
      @main       = ret.main
      @nest_list  = ret.nest_list
      @field_map = ret.field_map
  
  clone : ()->
    ret = new Type
    ret.main = @main
    for v in @nest_list
      ret.nest_list.push v.clone()
    for k,v of @field_map
      ret.field_map[k] = v.clone()
    ret
  
  cmp : (t)->
    return false if @main != t.main
    return false if @nest_list.length != t.nest_list.length
    for v,k in @nest_list
      return false if !t.nest_list[k].cmp v
    for k,v of @field_map
      return false if !tv = t.field_map[k]
      return false if !tv.cmp v
    for k,v of t.field_map
      return false if !tv = @field_map[k]
      # return false if !tv.cmp v
    true
  
  toString : ()->
    ret = @main
    if @nest_list.length
      jl = []
      for v in @nest_list
        jl.push v.toString()
      ret += "<#{jl.join ', '}>"
    
    jl = []
    for k,v of @field_map
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
        full_ret.field_map[key] = ret
        
        [_skip, tail] = /^(?:\s*(?:,\s*)?)(.*)$/.exec tail
      tail = tail.substr 1
    
    {ret:full_ret, tail}

module.exports = Type