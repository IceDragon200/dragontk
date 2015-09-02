module URI
  def self.valid?(str)
    !!(str =~ regexp)
  end
end
