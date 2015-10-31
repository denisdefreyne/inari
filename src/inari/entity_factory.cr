module EntityFactory
  def self.new_cursor
    Glove::Entity.new.tap do |e|
      e.texture = Glove::AssetManager.instance.texture_from("assets/cursorHand_blue.png")
      e.polygon = Glove::Quad.new
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

  def self.new_resume_button
    on_click = -> (en : Glove::Entity, ev : Glove::Event, sp : Glove::Space, app : Glove::EntityApp) do
      app.pop_scene
    end

    Glove::Entity.new.tap do |e|
      e.texture = Glove::AssetManager.instance.texture_from("assets/button_resume_normal.png")
      e.polygon = Glove::Quad.new
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
        "assets/button_resume_normal.png",
        "assets/button_resume_hover.png",
        "assets/button_resume_active.png",
      )
    end
  end

  def self.new_play_button
    on_click = -> (en : Glove::Entity, ev : Glove::Event, sp : Glove::Space, app : Glove::EntityApp) do
      app.replace_scene Glove::Scene.new.tap do |scene|
        scene.spaces << Glove::Space.new.tap do |main_space|
          main_space.entities << EntityFactory.new_quitter
          main_space.entities << EntityFactory.new_cursor
          main_space.entities << EntityFactory.new_camera
          main_space.actions << RestartAction.new(main_space)
        end

        scene.spaces << Glove::Space.new.tap do |ui_space|
        end
      end
    end

    Glove::Entity.new.tap do |e|
      e.texture = Glove::AssetManager.instance.texture_from("assets/button_play_normal.png")
      e.polygon = Glove::Quad.new
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
        "assets/button_play_normal.png",
        "assets/button_play_hover.png",
        "assets/button_play_active.png",
      )
    end
  end

  def self.new_quit_button
    on_click = -> (en : Glove::Entity, ev : Glove::Event, sp : Glove::Space, app : Glove::EntityApp) do
      LibGLFW.set_window_should_close(app.window, 1)
    end

    Glove::Entity.new.tap do |e|
      e.texture = Glove::AssetManager.instance.texture_from("assets/button_quit_normal.png")
      e.polygon = Glove::Quad.new
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

  def self.new_quitter
    Glove::Entity.new.tap do |e|
      e.keyboard_event_handler = PlaySceneEventHandler.new
    end
  end

  def self.new_camera
    Glove::Entity.new.tap do |e|
      e << Glove::Components::Camera.new
      e << Glove::Components::Transform.new
    end
  end

  def self.new_card(suit, num, idx)
    Glove::Entity.new.tap do |e|
      e.texture = Glove::AssetManager.instance.texture_from("assets/playing-cards/cardBack_blue4.png")
      e.polygon = Glove::Quad.new
      e.z = idx
      e << CardTypeComponent.new("#{suit}#{num}")
      e << Glove::Components::Transform.new.tap do |t|
        t.width = 140_f32
        t.height = 190_f32
        t.translate_x = 10_f32 + 550.0 / 6 + idx * 3
        t.translate_y = 0_f32 + 770.0 / 6
        t.anchor_x = 0.5_f32
        t.anchor_y = 0.5_f32
        t.scale_x = -1_f32
      end
      e.mouse_event_handler = CardMouseEventHandler.new
    end
  end
end
