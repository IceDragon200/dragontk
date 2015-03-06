require 'dragontk/thread_safe/hash'

class Hash
  def safe_wrap
    ThreadSafe::WrapHash.new(self)
  end
end
