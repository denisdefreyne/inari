class Glove::EntityApp < Glove::App
  property :space

  def initialize(width, height, title)
    super(width, height, title)

    @space = Glove::Space.new
    @renderer = Renderer.new(width, height)
  end

  def update(delta_time)
    # FIXME: also update child entities
    @space.entities.each { |e| e.update(delta_time, self) }
    @space.entities.remove_dead

    @space.actions.each { |a| a.update_wrapped(delta_time) }
    @space.actions.reject! { |a| a.done? }
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
    case event
    when Glove::Events::Key
      if entity = @space.entities.find { |e| e.keyboard_event_handler }
        if keyboard_event_handler = entity.keyboard_event_handler
          keyboard_event_handler.handle(event, entity, @space)
        end
      end
    when Glove::Events::MouseButton
      # Find entity
      entity =
        @space.entities.find do |entity|
          if entity.mouse_event_handler.nil?
            false
          elsif transform = entity.transform
            transform.bounds.contains?(event.location)
          else
            false
          end
        end

      # Pass on to entity
      if entity
        if mouse_event_handler = entity.mouse_event_handler
          mouse_event_handler.handle(event, entity, @space)
        end
      end
    end
  end
end
