# type
This module provides support for:
 * Scalars `int`, `bool`, `string`
 * Containers `array<int>`, `hash<int>`, `function<int,int>`
   * For example. `hash<int>`. Map with keys of type `string` and values of type `int`
 * Structs `struct{x: int, y: int}`
 * Null type like `void`
 
# Usage
 * `new Type 'int'`
 * `t1.cmp(t2)` compares two types
 * `"my type is #{t1}"` this class implements `toString()`, so interpolation works fine as well
