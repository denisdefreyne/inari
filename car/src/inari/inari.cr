require "glove"
require "./common"

if full_path = Process.executable_path
  Dir.cd(File.dirname(full_path))
end

app = Glove::EntityApp.new(1024, 512, "Inari")
app.clear_color = Glove::Color::WHITE

grass =
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Texture.new("assets/images/grass.png", 4f32, 2f32)
    e << Glove::Components::Z.new(-20.0_f32)
    e << RepeatTextureComponent.new
    e << Glove::Components::Transform.new.tap do |t|
      # screen size x2, rounded up to be a multiple of texture width/height
      t.width = 1024f32 * 2
      t.height = 1024f32
    end
  end

player =
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Texture.new("assets/images/car_black_1.png")
    e << Glove::Components::Z.new(15.0_f32)
    e << PlayerComponent.new
    e << CarComponent.new(Math::PI.to_f32/2, 0f32, 131f32, 0f32)
    e << Glove::Components::Transform.new.tap do |t|
      t.width = 71_f32
      t.height = 131_f32
      t.angle = 0f32
      t.anchor_x = 0.5_f32
      t.anchor_y = 0.9_f32
    end
  end

camera =
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Camera.new
    e << Glove::Components::Z.new(10.0_f32)
    e << FollowComponent.new(player, Glove::Vector.new(0f32, 0f32))
    e << Glove::Components::Transform.new.tap do |t|
      t.translate_x = 0f32
      t.translate_y = 0f32
      t.width = 0_f32
      t.height = 0_f32
      t.anchor_x = 0.5_f32
      t.anchor_y = 0.5_f32
    end
  end

scene =
  Glove::Scene.new.tap do |scene|
    scene.spaces << Glove::Space.new.tap do |space|
      space.entities << player
      space.entities << camera
      space.entities << grass

      space.systems << KeyInputSystem.new
      space.systems << UpdatePositionSystem.new
      space.systems << FollowSystem.new
      space.systems << RepeatTextureSystem.new
    end
  end

app.replace_scene(scene)
app.run
