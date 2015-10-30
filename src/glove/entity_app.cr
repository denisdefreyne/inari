class Glove::EntityApp < Glove::App
  property :spaces

  def initialize(width, height, title)
    super(width, height, title)

    @spaces = [] of Glove::Space
    @renderer = Renderer.new(width, height)
  end

  # TODO: remove
  def space
    @spaces[0]
  end

  def update(delta_time)
    # FIXME: also update child entities
    space.entities.each { |e| e.update(delta_time, self) }
    space.entities.remove_dead

    space.actions.each { |a| a.update_wrapped(delta_time) }
    space.actions.reject! { |a| a.done? }
  end

  def render(delta_time)
    @renderer.render(space.entities)
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
    space.handle_event(event)
  end
end
