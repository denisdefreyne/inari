require "glove"

class VelocityComponent < Glove::Component
  property :x
  property :y

  def initialize(@x : Float32, @y : Float32)
  end
end

####

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

####

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

# 928, 793
app = Glove::EntityApp.new(1024, 500, "Forest")
app.clear_color = Glove::Color::WHITE

forests = [] of Glove::Entity
forests <<
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Texture.new("assets/images/Layer_0010_1.png", 3f32, 2f32)
    e << Glove::Components::Z.new(-25.0_f32)
    e << SkyComponent.new
    e << Glove::Components::Parallax.new(0.1f32, 0f32, -300f32)
    e << Glove::Components::Color.new(Glove::Color.new(1f32, 1f32, 1f32, 1f32))
    e << Glove::Components::Transform.new.tap do |t|
      t.width = 2784f32 # screen size x2, rounded up to be a multiple of texture width
      t.height = 1586f32
      t.anchor_x = 0.5_f32
      t.anchor_y = 0.5_f32
    end
  end
forests <<
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Texture.new("assets/images/Layer_0009_2.png", 3f32, 2f32)
    e << Glove::Components::Z.new(-24.0_f32)
    e << SkyComponent.new
    e << Glove::Components::Parallax.new(0.15f32, 0f32, -300f32)
    e << Glove::Components::Color.new(Glove::Color.new(1f32, 1f32, 1f32, 1f32))
    e << Glove::Components::Transform.new.tap do |t|
      t.width = 2784f32 # screen size x2, rounded up to be a multiple of texture width
      t.height = 1586f32
      t.anchor_x = 0.5_f32
      t.anchor_y = 0.5_f32
    end
  end
forests <<
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Texture.new("assets/images/Layer_0008_3.png", 3f32, 2f32)
    e << Glove::Components::Z.new(-23.0_f32)
    e << SkyComponent.new
    e << Glove::Components::Parallax.new(0.2f32, 0f32, -300f32)
    e << Glove::Components::Color.new(Glove::Color.new(1f32, 1f32, 1f32, 1f32))
    e << Glove::Components::Transform.new.tap do |t|
      t.width = 2784f32 # screen size x2, rounded up to be a multiple of texture width
      t.height = 1586f32
      t.anchor_x = 0.5_f32
      t.anchor_y = 0.5_f32
    end
  end
forests <<
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Texture.new("assets/images/Layer_0007_Lights.png", 3f32, 2f32)
    e << Glove::Components::Z.new(-22.0_f32)
    e << SkyComponent.new
    e << Glove::Components::Parallax.new(0.3f32, 0f32, -300f32)
    e << Glove::Components::Color.new(Glove::Color.new(1f32, 1f32, 1f32, 1f32))
    e << Glove::Components::Transform.new.tap do |t|
      t.width = 2784f32 # screen size x2, rounded up to be a multiple of texture width
      t.height = 1586f32
      t.anchor_x = 0.5_f32
      t.anchor_y = 0.5_f32
    end
  end
forests <<
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Texture.new("assets/images/Layer_0006_4.png", 3f32, 2f32)
    e << Glove::Components::Z.new(-21.0_f32)
    e << SkyComponent.new
    e << Glove::Components::Parallax.new(0.4f32, 0f32, -300f32)
    e << Glove::Components::Color.new(Glove::Color.new(1f32, 1f32, 1f32, 1f32))
    e << Glove::Components::Transform.new.tap do |t|
      t.width = 2784f32 # screen size x2, rounded up to be a multiple of texture width
      t.height = 1586f32
      t.anchor_x = 0.5_f32
      t.anchor_y = 0.5_f32
    end
  end
forests <<
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Texture.new("assets/images/Layer_0005_5.png", 3f32, 2f32)
    e << Glove::Components::Z.new(-20.0_f32)
    e << SkyComponent.new
    e << Glove::Components::Parallax.new(0.5f32, 0f32, -300f32)
    e << Glove::Components::Color.new(Glove::Color.new(1f32, 1f32, 1f32, 1f32))
    e << Glove::Components::Transform.new.tap do |t|
      t.width = 2784f32 # screen size x2, rounded up to be a multiple of texture width
      t.height = 1586f32
      t.anchor_x = 0.5_f32
      t.anchor_y = 0.5_f32
    end
  end
forests <<
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Texture.new("assets/images/Layer_0004_Lights.png", 3f32, 2f32)
    e << Glove::Components::Z.new(-19.0_f32)
    e << SkyComponent.new
    e << Glove::Components::Parallax.new(0.6f32, 0f32, -300f32)
    e << Glove::Components::Color.new(Glove::Color.new(1f32, 1f32, 1f32, 1f32))
    e << Glove::Components::Transform.new.tap do |t|
      t.width = 2784f32 # screen size x2, rounded up to be a multiple of texture width
      t.height = 1586f32
      t.anchor_x = 0.5_f32
      t.anchor_y = 0.5_f32
    end
  end
forests <<
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Texture.new("assets/images/Layer_0003_6.png", 3f32, 2f32)
    e << Glove::Components::Z.new(-18.0_f32)
    e << SkyComponent.new
    e << Glove::Components::Parallax.new(0.7f32, 0f32, -300f32)
    e << Glove::Components::Color.new(Glove::Color.new(1f32, 1f32, 1f32, 1f32))
    e << Glove::Components::Transform.new.tap do |t|
      t.width = 2784f32 # screen size x2, rounded up to be a multiple of texture width
      t.height = 1586f32
      t.anchor_x = 0.5_f32
      t.anchor_y = 0.5_f32
    end
  end
forests <<
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Texture.new("assets/images/Layer_0002_7.png", 3f32, 2f32)
    e << Glove::Components::Z.new(-17.0_f32)
    e << SkyComponent.new
    e << Glove::Components::Parallax.new(0.85f32, 0f32, -300f32)
    e << Glove::Components::Color.new(Glove::Color.new(1f32, 1f32, 1f32, 1f32))
    e << Glove::Components::Transform.new.tap do |t|
      t.width = 2784f32 # screen size x2, rounded up to be a multiple of texture width
      t.height = 1586f32
      t.anchor_x = 0.5_f32
      t.anchor_y = 0.5_f32
    end
  end
forests <<
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Texture.new("assets/images/Layer_0001_8.png", 3f32, 2f32)
    e << Glove::Components::Z.new(-16.0_f32)
    e << SkyComponent.new
    e << Glove::Components::Parallax.new(1f32, 0f32, -300f32)
    e << Glove::Components::Color.new(Glove::Color.new(1f32, 1f32, 1f32, 1f32))
    e << Glove::Components::Transform.new.tap do |t|
      t.width = 2784f32 # screen size x2, rounded up to be a multiple of texture width
      t.height = 1586f32
      t.anchor_x = 0.5_f32
      t.anchor_y = 0.5_f32
    end
  end

camera =
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Camera.new
    e << Glove::Components::Z.new(10.0_f32)
    e << VelocityComponent.new(100.0f32, 0.0f32)
    e << Glove::Components::Transform.new.tap do |t|
      t.translate_x = 0f32
      t.translate_y = 300f32
      t.width = 0_f32
      t.height = 0_f32
      t.anchor_x = 0.5_f32
      t.anchor_y = 0.5_f32
    end
  end

scene =
  Glove::Scene.new.tap do |scene|
    scene.spaces << Glove::Space.new.tap do |space|
      forests.each { |f| space.entities << f }
      space.entities << camera

      space.systems << SkySystem.new
      space.systems << UpdatePositionSystem.new
    end
  end

app.replace_scene(scene)
app.run
