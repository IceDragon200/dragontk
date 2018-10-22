require_relative '../core/async'
require_relative 'interface'
require 'thread'
require 'ostruct'

module DragonTK
  module Workers
    class Base < Async::Worker
      include Workers::Interface

      def initialize_members(options)
        super
        @in = options.fetch(:in) { Queue.new }
      end

      def process(data)
        fail
      end

      def main
        loop do
          data = read
          if data == :HALT
            @logger.write msg: 'Received halt order'
            break
          end
          process data
        end
      end

      def stop
        self.in << :HALT
      end

      def stop!
        stop
        await
      end
    end
  end
end
