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
        t.anchor_x = 0.5_f32
        t.anchor_y = 0.5_f32
      end
    end
  end

  def self.new_play_button
    Glove::Entity.new.tap do |e|
      e.texture = Glove::AssetManager.instance.texture_from("assets/button_play_normal.png")
      e.polygon = Glove::Quad.new
      e.z = 100
      e << CursorTrackingComponent.new
      e << Glove::Components::Transform.new.tap do |t|
        t.width = 350_f32
        t.height = 70_f32
        t.translate_x = 475_f32
        t.translate_y = 400_f32
        t.anchor_x = 0.5_f32
        t.anchor_y = 0.5_f32
      end
      e.mouse_event_handler = PlayButtonMouseEventHandler.new
    end
  end

  def self.new_quit_button
    Glove::Entity.new.tap do |e|
      e.texture = Glove::AssetManager.instance.texture_from("assets/button_quit_normal.png")
      e.polygon = Glove::Quad.new
      e.z = 100
      e << CursorTrackingComponent.new
      e << Glove::Components::Transform.new.tap do |t|
        t.width = 350_f32
        t.height = 70_f32
        t.translate_x = 475_f32
        t.translate_y = 300_f32
        t.anchor_x = 0.5_f32
        t.anchor_y = 0.5_f32
      end
      e.mouse_event_handler = QuitButtonMouseEventHandler.new
    end
  end

  def self.new_quitter
    Glove::Entity.new.tap do |e|
      e << QuitComponent.new
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
