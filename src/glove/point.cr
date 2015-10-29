struct Glove::Point
  property :x
  property :y

  def initialize(@x : Float32, @y : Float32)
  end

  def +(other)
    self.class.new(x + other.x, y + other.y)
  end
end
