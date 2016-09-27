struct ClickEventHandler < Glove::EventHandler
  def initialize(@filename_normal : String, @filename_hover : String, @filename_active : String)
  end

  def handle(event, entity, space, app)
    cursor_tracking = entity[Glove::Components::CursorTracking]?

    case event
    when Glove::Events::CursorEntered
      if cursor_tracking && cursor_tracking.pressed?
        entity.texture = Glove::AssetManager.instance.texture_from(@filename_active)
      else
        entity.texture = Glove::AssetManager.instance.texture_from(@filename_hover)
      end
    when Glove::Events::CursorExited
      entity.texture = Glove::AssetManager.instance.texture_from(@filename_normal)
    when Glove::Events::MousePressed
      if cursor_tracking
        cursor_tracking.pressed = true
      end
      entity.texture = Glove::AssetManager.instance.texture_from(@filename_active)
    when Glove::Events::MouseReleased
      if cursor_tracking
        if cursor_tracking.pressed? && cursor_tracking.inside?
          if on_click_component = entity[OnClickComponent]?
            on_click_component.proc.call(entity, event, space, app)
            entity.texture = Glove::AssetManager.instance.texture_from(@filename_hover)
          end
        end
        cursor_tracking.pressed = false
      end
    end
  end
end
