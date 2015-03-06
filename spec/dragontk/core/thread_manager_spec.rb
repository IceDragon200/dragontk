require_relative '../../spec_helper'

describe ThreadManager do
  context ".spawn" do
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
    end
  end
end
