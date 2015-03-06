require 'dragontk/thread_safe/wrapper'

class Object
  def safe_wrap
    ThreadSafe::Wrapper.new(self)
  end
end
