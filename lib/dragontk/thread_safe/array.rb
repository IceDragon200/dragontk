require_relative 'wrapper'

module ThreadSafe
  class WrapArray < Wrapper
    wrap :<<
    wrap :[]
    wrap :[]=
    wrap :blank?
    wrap :concat
    wrap :delete
    wrap :each
    wrap :empty?
    wrap :include?
    wrap :map
    wrap :push
    wrap :pop
    wrap :shift
    wrap :size
  end
end
