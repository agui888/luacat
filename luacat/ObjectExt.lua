-- ObjectExt.lua
--                           wookay.noh at gmail.com 


local inspect = require 'inspect'


function extends(superclass)
  local klass = { }
  klass.superclass = superclass
  klass.mt = {
    __index = function(self, name)
      if 'class' == name then
        return klass
      elseif "nil" ~= self.__type and 'table' == type(self.__value) then
        for k,v in pairs(self.__value) do
          if k == name then
            return v
          end
       end
      end
      for k,v in pairs(klass) do
        if k == name then
          return function(...) 
            return v(self.__value, ...)
          end 
        end
      end
      local super = superclass
      while nil ~= super do
        for k,v in pairs(super) do
          if k == name then
            return function(...)
              return v(self.__value, ...)
            end
          end
        end
        super = super.superclass
      end
      return nil
    end,
  }
  klass.new = function()
    local initialize = klass.initialize
    local obj = {}
    if 'function' == type(initialize) then
      initialize(obj)
    end 
    return new_object(obj, klass.mt, 'object')
  end
  return klass
end


Object = { mt = {} }
Number = extends(Object)
String = extends(Object)
Table = extends(Object)
Nil = extends(Object)
Boolean = extends(Object)
Function = extends(Object)


function new_object(value, mt, objType)
  local valueTable = { __type = objType, __value = value}
  setmetatable(valueTable, mt)
  return valueTable
end

function _(obj)
  local mtMap = {
    boolean = Boolean.mt,
    number = Number.mt,
    string = String.mt,
    table = Table.mt,
  }
  mtMap['nil'] = Nil.mt
  mtMap['function'] = Function.mt
  local objType = type(obj)
  local mt = mtMap[objType]
  return new_object(obj, mt, objType)
end

function is_nil(obj)
  return nil == obj
end

function is_not_nil(obj)
  return nil ~= obj
end



Object.is_nil = function(self)
  return is_nil(self)
end

Object.is_not_nil = function(self)
  return is_not_nil(self)
end

function Object.methods(obj)
  local ary = {}
  for k,v in pairs(obj) do
    if "function" == type(v) then
      table.insert(ary, k)
    end
  end
  return ary
end

function Object.method(obj, method)
  return obj[method]
end
