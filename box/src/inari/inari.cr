require "glove"

game = Glove::EntityApp.new(950, 650, "Inari")
game.clear_color = Glove::Color::WHITE

card =
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Texture.new("assets/card.png")
    e << Glove::Components::Z.new(-10.0_f32)
    e << Glove::Components::Transform.new.tap do |t|
      t.width = 140_f32
      t.height = 190_f32
      t.translate_x = game.width.to_f32 / 2
      t.translate_y = game.height.to_f32 / 2
      t.anchor_x = 0.5_f32
      t.anchor_y = 0.5_f32
    end
  end

scene =
  Glove::Scene.new.tap do |scene|
    scene.spaces << Glove::Space.new.tap do |space|
      space.entities << card
    end
  end

game.replace_scene(scene)
game.run
