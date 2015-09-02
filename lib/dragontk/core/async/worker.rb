require 'securerandom'
require 'moon-logfmt/logfmt'
require 'dragontk/core_ext/ostruct'

module DragonTK
  module Async
    class Worker
      # @!attribute id
      #   @return [String]
      attr_reader :id

      # @!attribute logger
      #   @return [Logfmt::Logger]
      attr_accessor :logger

      attr_accessor :settings

      def initialize(options = {})
        @settings = OpenStruct.conj(options.fetch(:settings, {}))
        initialize_members options
        run if options[:run]
      end

      def initialize_members(options)
        @id = SecureRandom.hex(16)
        @logger = options.fetch(:logger) do
          l = Moon::Logfmt::Logger.new
          l.io = NullIO::OUT
          l
        end
        @run_mutex = Mutex.new
      end

      def run
        l = @logger.new fn: 'run'
        l.write state: 'starting'
        @thread = Thread.new do
          l.write state: 'preparing'
          prepare
          l.write state: 'main'
          main
          l.write state: 'terminating'
          terminate
          l.write state: 'discarding_thread'
          @thread = nil
        end
      end

      def prepare
      end

      def main
      end

      # place extra things that need to be awaited here
      def internal_await
      end

      def terminate
        # wait for anything else that may be running
        internal_await
      end

      def await
        @logger.write fn: 'await'
        if @thread
          @thread.join
          @thread = nil
        end
      end
    end
  end
end
