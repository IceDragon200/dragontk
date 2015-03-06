require 'dragontk/thread_safe/wrapper'

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
    wrap :map
    wrap :push
    wrap :size
  end
end
