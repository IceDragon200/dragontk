require_relative 'object'
require_relative '../io'

class IO
  def thread_safe
    ThreadSafe::WrapIO.new(self)
  end
end
