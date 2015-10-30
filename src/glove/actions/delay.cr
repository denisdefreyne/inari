class Glove::Actions::Delay < Glove::IntervalAction
  def initialize(@entity : Glove::Entity, @duration : Float32)
    super(@duration)
  end

  def update(delta_time)
  end
end
