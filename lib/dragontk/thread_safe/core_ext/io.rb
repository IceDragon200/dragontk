require 'dragontk/thread_safe/core_ext/object'
require 'dragontk/thread_safe/io'

class IO
  def thread_safe
    ThreadSafe::WrapIO.new(self)
  end
end
