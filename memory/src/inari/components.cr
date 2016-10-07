# Updates the entity’s translation based on the cursor position.
class CursorFollowingComponent < ::Glove::Component
  def update(entity, delta_time, space, app)
    if transform = entity[Glove::Components::Transform]
      transform.translate_x = app.cursor_position.x
      transform.translate_y = app.cursor_position.y
    end
  end
end

class OnClickComponent < ::Glove::Component
  getter :proc

  def initialize(@proc : (Glove::Entity, Glove::Event, Glove::Space, Glove::EntityApp ->))
  end
end

class CardTypeComponent < ::Glove::Component
  getter :string

  def initialize(@string : String)
  end
end

class VisibleComponent < ::Glove::Component
end
