module DragonTK
  module Version
    MAJOR, MINOR, TEENY, PATCH = 1, 5, 3, nil
    STRING = [MAJOR, MINOR, TEENY, PATCH].compact.join(".").freeze
  end
  VERSION = Version::STRING
end
