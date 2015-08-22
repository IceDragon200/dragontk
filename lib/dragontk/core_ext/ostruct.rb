require 'ostruct'

class OpenStruct
  # For merging any object that responds to each_pair into a new OpenStruct
  #
  # @param [#each_pair] args
  # @return [OpenStruct]
  def self.conj(*args)
    new.tap do |c|
      args.each do |b|
        b.each_pair do |k, v|
          c[k] = v
        end
      end
    end
  end
end
