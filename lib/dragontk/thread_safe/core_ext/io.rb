require 'dragontk/thread_safe/io'

class IO
  def safe_wrap
    ThreadSafe::WrapIO.new(self)
  end
end
