struct PauseSceneEventHandler < Glove::EventHandler
  def handle(event, entity, space, app)
    case event
    when Glove::Events::Key
      if event.pressed?
        if event.key == Glove::Key::KEY_ESCAPE
          app.pop_scene
        end
      end
    end
  end
end
