require 'spec_helper'
require 'dragontk/thread_pool'

describe DragonTK::ThreadPool do
  context "#spawn/0" do
    it "should spawn and complete all threads" do
      result = {}
      10.times do |j|
        result[j] = {}
        subject.spawn do
          5.times do |i|
            result[j][i] = j * i
          end
        end
      end

      subject.await

      10.times do |j|
        5.times do |i|
          expect(result[j][i]).to eq(j * i)
        end
      end
    end

    it "should spawn a new sub thread" do
      subject.spawn do
        5.times do
          puts "Hello World"
          sleep 0.01
        end
      end

      subject.spawn do
        5.times do
          puts "On other news"
          sleep 0.01
        end
      end

      subject.spawn do
        5.times do
          puts "if anything, I'd say he's crazy"
          sleep 0.01
        end
      end

      subject.await
    end
  end
end
