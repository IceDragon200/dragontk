require 'securerandom'
require 'moon-logfmt/logfmt'
require_relative '../../core_ext/ostruct'
require_relative '../../workers/channel'

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

      # @!attribute state_channel - pushes the state changes in the worker
      #   @return [DragonTK::Worker::Channel]
      attr_reader :state_channel

      attr_reader :thread

      def initialize(**options)
        @settings = OpenStruct.conj(options.fetch(:settings, {}))
        @state_channel = DragonTK::Workers::Channel.new
        initialize_members(**options)
        run if options[:run]
      end

      protected def initialize_members(**options)
        @id = SecureRandom.hex(4)
        @logger = options.fetch(:logger, Kona::Logfmt::NULL)
      end

      def alive?
        @thread && @thread.alive?
      end

      def run
        l = @logger.new fn: 'run'
        l.write state: 'starting'
        @thread = Thread.new do
          #
          l.write state: 'preparing'
          state_channel << :prepare
          prepare
          begin
            #
            l.write state: 'main'
            state_channel << :main
            main
          ensure
            #
            begin
              l.write state: 'terminating'
              state_channel << :terminate
              terminate
            ensure
              state_channel << :dead
            end
          end
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
        @thread&.join if @thread.alive?
        @thread = nil
      end

      def kill
        @thread&.kill if @thread
        @thread = nil
      end
    end
  end
end
