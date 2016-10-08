module EntityFactory
  def self.new_resume_button
    on_click = -> (en : Glove::Entity, ev : Glove::Event, sp : Glove::Space, app : Glove::EntityApp) do
      app.pop_scene
    end

    Glove::Entity.new.tap do |e|
      e << Glove::Components::Texture.new("assets/button_resume_normal.png")
      e << Glove::Components::Z.new(10.0_f32)
      e << Glove::Components::CursorTracking.new
      e << OnClickComponent.new(on_click)
      e << Glove::Components::Transform.new.tap do |t|
        t.width = 350_f32
        t.height = 70_f32
        t.translate_x = 475_f32
        t.translate_y = 400_f32
        t.anchor_x = 0.5_f32
        t.anchor_y = 0.5_f32
      end
      e.mouse_event_handler = ClickEventHandler.new(
        "assets/button_resume_normal.png",
        "assets/button_resume_hover.png",
        "assets/button_resume_active.png",
      )
    end
  end

  def self.new_pause_scene_event_handler
    Glove::Entity.new.tap do |e|
      e.keyboard_event_handler = PauseSceneEventHandler.new
    end
  end
end
