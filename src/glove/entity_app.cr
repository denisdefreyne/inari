class Glove::EntityApp < Glove::App
  property :scene

  def initialize(width, height, title)
    super(width, height, title)

    @scene = Glove::Scene.new
    @renderer = Renderer.new(width, height)
  end

  def update(delta_time)
    @scene.spaces.each &.update(delta_time, self)
  end

  def render(delta_time)
    @scene.spaces.each { |s| @renderer.render(s.entities) }
  end

  def cleanup
  end

  def bounds
    Rect.new(
      Point.new(0_f32, 0_f32),
      Size.new(@width.to_f32, @height.to_f32),
    )
  end

  def handle_event(event : Glove::Event)
    scene.spaces.each do |space|
      space.handle_event(event, self)
    end
  end
end
