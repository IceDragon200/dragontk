require 'dragontk/thread_safe/array'

class Array
  def safe_wrap
    ThreadSafe::WrapArray.new(self)
  end
end
