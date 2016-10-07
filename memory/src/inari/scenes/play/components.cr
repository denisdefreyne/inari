class ScoringComponent < ::Glove::Component
  getter :time
  getter :clicks

  def initialize
    @time = 0_f32
    @clicks = 0_i32
  end

  def record_click
    @clicks += 1
  end

  def update(entity, delta_time, space, app)
    @time += delta_time
  end
end
