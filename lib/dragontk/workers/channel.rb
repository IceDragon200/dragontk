require 'dragontk/workers/interface'

module DragonTK
  module Workers
    class Channel
      include DragonTK::Workers::Interface

      def <<(data)
        write data
      end
    end
  end
end
