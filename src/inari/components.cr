class QuitComponent < ::Glove::Component
  def update(entity, delta_time, space, app)
    if LibGLFW.get_key(app.window, LibGLFW::KEY_ESCAPE) == LibGLFW::PRESS
      LibGLFW.set_window_should_close(app.window, 1)
    end
  end
end

# Updates the entity’s translation based on the cursor position.
class CursorFollowingComponent < ::Glove::Component
  def update(entity, delta_time, space, app)
    if transform = entity.transform
      transform.translate_x = app.cursor_position.x
      transform.translate_y = app.cursor_position.y
    end
  end
end

class OnClickComponent < ::Glove::Component
  getter :proc

  def initialize(@proc : (Glove::Entity, Glove::Event, Glove::Space, Glove::App ->))
  end
end

# Listens to changes in cursor position and sets inside/outside.
class CursorTrackingComponent < ::Glove::Component
  getter? :inside
  property? :pressed

  def initialize
    @inside = false
    @pressed = false
  end

  def update(entity, delta_time, space, app)
    if transform = entity.transform
      bounds = transform.bounds
      point = Glove::Point.new(app.cursor_position.x, app.cursor_position.y)
      new_inside = bounds.contains?(point)

      if @inside != new_inside
        if event_handler = entity.mouse_event_handler
          event_handler.handle(
            new_inside ? Glove::Events::CursorEntered.new : Glove::Events::CursorExited.new,
            entity,
            space,
            app
          )
        end
      end

      @inside = new_inside
    end
  end
end

class CardTypeComponent < ::Glove::Component
  getter :string

  def initialize(@string)
  end
end

class VisibleComponent < ::Glove::Component
end
