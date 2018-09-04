require_relative '../core/async'
require_relative 'stop'
require_relative 'interface'
require 'thread'
require 'ostruct'

module DragonTK
  module Workers
    class Base < Async::Worker
      include Workers::Interface

      def initialize_members(options)
        super
        @in = Queue.new
      end

      def process(data)
        fail
      end

      def main
        loop do
          data = read
          if data == Stop
            @logger.write msg: 'Received stop order'
            break
          end
          process data
        end
      end

      def stop
        self.in << Stop
      end

      def stop!
        stop
        await
      end
    end
  end
end
