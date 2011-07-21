-- test_numberext.lua
--                           wookay.noh at gmail.com

package.path = package.path .. ";../luacat/?.lua"
require 'UnitTest'
require 'NumberExt'
require 'Logger'

function test_number()
  assert_equal("a", int_to_char(97))
  assert_equal(97, char_to_int("a"))
  assert_equal("1", to_s(1))

  assert_equal(1, string_to_int("1"))
  assert_equal(3.14, string_to_float("3.14"))
  assert_true(3.141592653589 < PI)
  
  assert_false(is_odd(0))
  assert_true(is_odd(1))
  assert_false(is_odd(2))
  assert_true(is_odd(3))

  local random = get_random(2)
  assert_true(0 <= random)
end



if is_main() then 
  UnitTest.run()
end
