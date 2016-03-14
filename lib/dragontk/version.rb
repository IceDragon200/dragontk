module DragonTK
  module Version
    MAJOR, MINOR, TEENY, PATCH = 1, 9, 2, nil
    STRING = [MAJOR, MINOR, TEENY, PATCH].compact.join(".").freeze
  end
  VERSION = Version::STRING
end
