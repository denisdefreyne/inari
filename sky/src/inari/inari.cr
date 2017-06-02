require "glove"

class AccelerationComponent < Glove::Component
  property :x
  property :y

  def initialize(@x : Float32, @y : Float32)
  end
end

class VelocityComponent < Glove::Component
  property :x
  property :y

  def initialize(@x : Float32, @y : Float32)
  end
end

class KeyInputComponent < Glove::Component
end

class UpdateAccelerationSystem < Glove::System
  def update(delta_time, space, app)
    es = space.entities.select { |e| e[KeyInputComponent]? && e[AccelerationComponent]? }
    es.each do |e|
      ki = e[KeyInputComponent]
      acc = e[AccelerationComponent]

      acc.x = 0f32
      acc.x += -500f32 if app.key_pressed?(Glove::Key::KEY_LEFT)
      acc.x += 500f32 if app.key_pressed?(Glove::Key::KEY_RIGHT)

      acc.y = 0f32
      acc.y += -500f32 if app.key_pressed?(Glove::Key::KEY_DOWN)
      acc.y += 500f32 if app.key_pressed?(Glove::Key::KEY_UP)
    end
  end
end

class UpdateVelocitySystem < Glove::System
  def update(delta_time, space, app)
    es = space.entities.select { |e| e[AccelerationComponent]? && e[VelocityComponent]? }
    es.each do |e|
      acc = e[AccelerationComponent]
      vel = e[VelocityComponent]

      vel.x += acc.x * delta_time
      vel.y += acc.y * delta_time
    end
  end
end

class UpdatePositionSystem < Glove::System
  def update(delta_time, space, app)
    es = space.entities.select { |e| e[VelocityComponent]? && e[Glove::Components::Transform]? }
    es.each do |e|
      vel = e[VelocityComponent]
      tr = e[Glove::Components::Transform]

      tr.translate_x += vel.x * delta_time
      tr.translate_y += vel.y * delta_time
    end
  end
end

################################################################################

class SkyComponent < Glove::Component
end

class SkySystem < Glove::System
  def update(delta_time, space, app)
    space.entities.all_with_component(SkyComponent).each do |entity|
      cameras = space.entities.all_with_component(Glove::Components::Camera)
      if camera = cameras[0]?
        if ct = camera[Glove::Components::Transform]?
          pf =
            if pc = entity[Glove::Components::Parallax]?
              pc.factor
            else
              1.0
            end

          transform = entity[Glove::Components::Transform]
          texture = entity[Glove::Components::Texture]
          texture_width = transform.width / texture.width

          dx = (ct.translate_x * pf / texture_width + 0.5).floor * texture_width / pf
          entity[Glove::Components::Transform].translate_x = dx.to_f32
        end
      end
    end
  end
end

################################################################################

if full_path = Process.executable_path
  Dir.cd(File.dirname(full_path))
end

app = Glove::EntityApp.new(1024, 512, "Inari")
app.clear_color = Glove::Color::WHITE

sky_close =
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Texture.new("assets/images/sky.png", 2f32)
    e << Glove::Components::Z.new(-20.0_f32)
    e << SkyComponent.new
    e << Glove::Components::Parallax.new(0.5f32)
    e << Glove::Components::Color.new(Glove::Color.new(1f32, 1f32, 1f32, 1f32))
    e << Glove::Components::Transform.new.tap do |t|
      t.width = 2048f32 # screen size x2, rounded up to be a multiple of texture width
      t.height = 512_f32
    end
  end

sky_distant =
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Texture.new("assets/images/sky2.png", 2f32)
    e << Glove::Components::Z.new(-19.0_f32)
    e << SkyComponent.new
    e << Glove::Components::Parallax.new(0.3f32)
    e << Glove::Components::Color.new(Glove::Color.new(1f32, 1f32, 1f32, 0.5f32))
    e << Glove::Components::Transform.new.tap do |t|
      t.width = 2048f32 # screen size x2, rounded up to be a multiple of texture width
      t.height = 512_f32
    end
  end

player_and_cam =
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Camera.new
    e << KeyInputComponent.new
    e << VelocityComponent.new(0.0f32, 0.0f32)
    e << AccelerationComponent.new(0.0f32, 0.0f32)
    e << Glove::Components::Z.new(10.0_f32)
    e << Glove::Components::Transform.new.tap do |t|
      t.translate_x = 0f32
      t.translate_y = 0f32
      t.width = 0_f32
      t.height = 0_f32
      t.anchor_x = 0.5_f32
      t.anchor_y = 0.5_f32
    end
  end

player =
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Color.new(Glove::Color.new(0f32, 0f32, 0f32, 0.5f32))
    e << Glove::Components::Z.new(15.0_f32)
    e << Glove::Components::Transform.new.tap do |t|
      t.width = 50_f32
      t.height = 100_f32
      t.anchor_x = 0.5_f32
      t.anchor_y = 0.5_f32
    end
  end

def gen_tree(x, w, h, z, r, pf)
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Color.new(Glove::Color.new(r, 0f32, 0f32, 1.0f32))
    e << Glove::Components::Z.new(z)
    e << Glove::Components::Parallax.new(pf)
    e << Glove::Components::Transform.new.tap do |t|
      t.width = w
      t.height = h
      t.anchor_x = 0.5_f32
      t.anchor_y = 0.5_f32
      t.translate_x = x
    end
  end
end

player_and_cam.children << player

scene =
  Glove::Scene.new.tap do |scene|
    scene.spaces << Glove::Space.new.tap do |space|
      space.entities << sky_distant
      space.entities << sky_close
      space.entities << player_and_cam

      space.entities << gen_tree(200f32, 10f32, 150f32, 4f32, 0.6f32, 0.8f32)
      space.entities << gen_tree(400f32, 10f32, 150f32, 4f32, 0.6f32, 0.8f32)
      space.entities << gen_tree(600f32, 10f32, 150f32, 4f32, 0.6f32, 0.8f32)
      space.entities << gen_tree(800f32, 10f32, 150f32, 4f32, 0.6f32, 0.8f32)
      space.entities << gen_tree(1000f32, 10f32, 150f32, 4f32, 0.6f32, 0.8f32)
      space.entities << gen_tree(1200f32, 10f32, 150f32, 4f32, 0.6f32, 0.8f32)
      space.entities << gen_tree(1400f32, 10f32, 150f32, 4f32, 0.6f32, 0.8f32)
      space.entities << gen_tree(1600f32, 10f32, 150f32, 4f32, 0.6f32, 0.8f32)
      space.entities << gen_tree(1800f32, 10f32, 150f32, 4f32, 0.6f32, 0.8f32)

      space.entities << gen_tree(200f32, 15f32, 180f32, 5f32, 0.8f32, 1.0f32)
      space.entities << gen_tree(400f32, 15f32, 180f32, 5f32, 0.8f32, 1.0f32)
      space.entities << gen_tree(600f32, 15f32, 180f32, 5f32, 0.8f32, 1.0f32)
      space.entities << gen_tree(800f32, 15f32, 180f32, 5f32, 0.8f32, 1.0f32)
      space.entities << gen_tree(1000f32, 15f32, 180f32, 5f32, 0.8f32, 1.0f32)
      space.entities << gen_tree(1200f32, 15f32, 180f32, 5f32, 0.8f32, 1.0f32)
      space.entities << gen_tree(1400f32, 15f32, 180f32, 5f32, 0.8f32, 1.0f32)
      space.entities << gen_tree(1600f32, 15f32, 180f32, 5f32, 0.8f32, 1.0f32)
      space.entities << gen_tree(1800f32, 15f32, 180f32, 5f32, 0.8f32, 1.0f32)

      space.entities << gen_tree(200f32, 20f32, 300f32, 20f32, 1f32, 1.5f32)
      space.entities << gen_tree(400f32, 20f32, 300f32, 20f32, 1f32, 1.5f32)
      space.entities << gen_tree(600f32, 20f32, 300f32, 20f32, 1f32, 1.5f32)
      space.entities << gen_tree(800f32, 20f32, 300f32, 20f32, 1f32, 1.5f32)
      space.entities << gen_tree(1000f32, 20f32, 300f32, 20f32, 1f32, 1.5f32)
      space.entities << gen_tree(1200f32, 20f32, 300f32, 20f32, 1f32, 1.5f32)
      space.entities << gen_tree(1400f32, 20f32, 300f32, 20f32, 1f32, 1.5f32)
      space.entities << gen_tree(1600f32, 20f32, 300f32, 20f32, 1f32, 1.5f32)
      space.entities << gen_tree(1800f32, 20f32, 300f32, 20f32, 1f32, 1.5f32)

      space.systems << UpdateAccelerationSystem.new
      space.systems << UpdateVelocitySystem.new
      space.systems << UpdatePositionSystem.new
      space.systems << SkySystem.new
    end
  end

app.replace_scene(scene)
app.run
