module EntityFactory
  def self.new_play_again_button
    new_play_button("play_again")
  end

  def self.new_play_button(type = "play")
    on_click = -> (en : Glove::Entity, ev : Glove::Event, sp : Glove::Space, app : Glove::EntityApp) do
      app.replace_scene(SceneFactory.new_play_scene)
    end

    Glove::Entity.new.tap do |e|
      e.texture = Glove::AssetManager.instance.texture_from("assets/button_#{type}_normal.png")
      e.z = 100
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
        "assets/button_#{type}_normal.png",
        "assets/button_#{type}_hover.png",
        "assets/button_#{type}_active.png",
      )
    end
  end

  def self.new_cursor
    Glove::Entity.new.tap do |e|
      e.texture = Glove::AssetManager.instance.texture_from("assets/cursorHand_blue.png")
      e.z = 100
      e << CursorFollowingComponent.new
      e << Glove::Components::Transform.new.tap do |t|
        t.width = 30_f32
        t.height = 33_f32
        t.translate_x = 0_f32
        t.translate_y = 0_f32
        t.anchor_x = 0.1_f32
        t.anchor_y = 0.9_f32
      end
    end
  end

  def self.new_quit_button
    on_click = -> (en : Glove::Entity, ev : Glove::Event, sp : Glove::Space, app : Glove::EntityApp) do
      app.quit
    end

    Glove::Entity.new.tap do |e|
      e.texture = Glove::AssetManager.instance.texture_from("assets/button_quit_normal.png")
      e.z = 100
      e << Glove::Components::CursorTracking.new
      e << OnClickComponent.new(on_click)
      e << Glove::Components::Transform.new.tap do |t|
        t.width = 350_f32
        t.height = 70_f32
        t.translate_x = 475_f32
        t.translate_y = 300_f32
        t.anchor_x = 0.5_f32
        t.anchor_y = 0.5_f32
      end
      e.mouse_event_handler = ClickEventHandler.new(
        "assets/button_quit_normal.png",
        "assets/button_quit_hover.png",
        "assets/button_quit_active.png",
      )
    end
  end

  def self.new_camera
    Glove::Entity.new.tap do |e|
      e << Glove::Components::Camera.new
      e << Glove::Components::Transform.new.tap do |t|
        t.translate_x = 950_f32/2
        t.translate_y = 650_f32/2
      end
    end
  end
end
