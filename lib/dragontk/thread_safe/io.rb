require 'dragontk/thread_safe/wrapper'

##
# Wrapper class for an IO, employing an internal mutex to prevent multiple
# reads or writes at once.
module ThreadSafe
  class WrapIO < Wrapper
    wrap :<<
    wrap :gets
    wrap :print
    wrap :puts
    wrap :read
    wrap :write
    wrap :flush

    def tty?
      @value.tty?
    end
  end
end
