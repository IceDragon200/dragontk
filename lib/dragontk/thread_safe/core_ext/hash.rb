require_relative 'object'
require_relative '../hash'

class Hash
  def thread_safe
    ThreadSafe::WrapHash.new(self)
  end
end
