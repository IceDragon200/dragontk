require 'dragontk/thread_safe/core_ext/object'
require 'dragontk/thread_safe/hash'

class Hash
  def thread_safe
    ThreadSafe::WrapHash.new(self)
  end
end
