require_relative '../generic'

class Object
  def thread_safe
    ThreadSafe::GenericWrapper.new(self)
  end

  def safe_wrap
    warn '#safe_wrap is deprecated, use #thread_safe instead'
    thread_safe
  end
end
