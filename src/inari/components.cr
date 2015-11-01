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

class CardTypeComponent < ::Glove::Component
  getter :string

  def initialize(@string)
  end
end

class VisibleComponent < ::Glove::Component
end

# TODO: This needs to come last.
class ConstrainWithinScreenBoundsComponent < ::Glove::Component
  def update(entity, delta_time, space, app)
    if transform = entity[Glove::Components::Transform]
      if transform.translate_x < 0_f32
        transform.translate_x = 0_f32
      end

      if transform.translate_x > app.width
        transform.translate_x = app.width.to_f32
      end

      if transform.translate_y < 0_f32
        transform.translate_y = 0_f32
      end

      if transform.translate_y > app.height
        transform.translate_y = app.height.to_f32
      end
    end
  end
end
