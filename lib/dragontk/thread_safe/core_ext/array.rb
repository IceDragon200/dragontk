require 'dragontk/thread_safe/core_ext/object'
require 'dragontk/thread_safe/array'

class Array
  def thread_safe
    ThreadSafe::WrapArray.new(self)
  end
end
