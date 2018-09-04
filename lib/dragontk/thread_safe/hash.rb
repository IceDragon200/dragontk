require_relative 'wrapper'

module ThreadSafe
  class WrapHash < Wrapper
    wrap :[]
    wrap :[]=
    wrap :blank?
    wrap :delete
    wrap :each
    wrap :empty?
    wrap :fetch
    wrap :key?
    wrap :map
    wrap :size
    wrap :value?
  end
end
