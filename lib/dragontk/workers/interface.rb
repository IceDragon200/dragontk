module DragonTK
  module Workers
    module Interface
      module Writer
        attr_accessor :out

        def write(data)
          self.out << data if self.out
        end
      end

      module Reader
        attr_accessor :in

        def read
          return nil unless self.in
          self.in.pop
        end
      end

      include Writer
      include Reader
    end
  end
end
