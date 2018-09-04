require_relative 'object'
require_relative '../array'

class Array
  def thread_safe
    ThreadSafe::WrapArray.new(self)
  end
end
