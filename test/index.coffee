assert = require 'assert'

Type = require '../src/index.coffee'

describe 'index section', ()->
  it 'create type', ()->
    t = new Type
    return
  
  describe 'toString', ()->
    it 'simple', ()->
      t = new Type
      t.main = 'a'
      assert.equal t.toString(), 'a'
      return
    
    it 'nest', ()->
      t = new Type
      t.main = 'a'
      t.nest_list.push t2 = new Type
      t2.main = 'b'
      assert.equal t.toString(), 'a<b>'
      return
    
    it 'nest2', ()->
      t = new Type
      t.main = 'a'
      t.nest_list.push t2 = new Type
      t2.main = 'b'
      t.nest_list.push t2 = new Type
      t2.main = 'c'
      assert.equal t.toString(), 'a<b, c>'
      return
    
    it 'field', ()->
      t = new Type
      t.main = 'a'
      t.field_hash.k1 = t2 = new Type
      t2.main = 'b'
      assert.equal t.toString(), 'a{k1: b}'
      return
    
    it 'field2', ()->
      t = new Type
      t.main = 'a'
      t.field_hash.k1 = t2 = new Type
      t2.main = 'b'
      t.field_hash.k2 = t2 = new Type
      t2.main = 'c'
      assert.equal t.toString(), 'a{k1: b, k2: c}'
      return
  
  
  describe 'parse', ()->
    it 'simple', ()->
      assert.equal (new Type str = 'a').toString(), str
      return
    
    it 'nest', ()->
      assert.equal (new Type str = 'a<b>').toString(), str
      return
    
    it 'nest2', ()->
      assert.equal (new Type str = 'a<b, c>').toString(), str
      return
    
    it 'field', ()->
      assert.equal (new Type str = 'a{k1: b}').toString(), str
      return
    
    it 'field2', ()->
      assert.equal (new Type str = 'a{k1: b, k2: c}').toString(), str
      return
    
    it 'nest field', ()->
      assert.equal (new Type str = 'a<b>{k1: c}').toString(), str
      return
    
    it 'throw invalid type identifier', ()->
      assert.throws ()->
        new Type ','
      return
    
    it 'throw unparsed tail', ()->
      assert.throws ()->
        new Type 'a,'
      return
    
    it 'throw missing >', ()->
      assert.throws ()->
        new Type 'a<b'
      return
    
    it 'throw missing }', ()->
      assert.throws ()->
        new Type 'a{k1: b'
      return
    
    it 'throw missing :', ()->
      assert.throws ()->
        new Type 'a{k1 b}'
      return
  
  describe 'clone', ()->
    it 'is different', ()->
      a = new Type 'a'
      a1 = a.clone()
      assert a != a1
    
    it 'same string', ()->
      test = (str)->
        a = new Type str
        a1 = a.clone()
        assert.equal a.toString(), a1.toString()
      test 'a'
      test 'a<b>'
      test 'a<b>{k1: c}'
      test 'a{k1: c}'
    