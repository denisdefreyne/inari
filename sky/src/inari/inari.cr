require "glove"

class PlayerComponent < Glove::Component
end

####

class VelocityComponent < Glove::Component
  property :x
  property :y

  def initialize(@x : Float32, @y : Float32)
  end
end

####

class KeyInputComponent < Glove::Component
end

class KeyInputSystem < Glove::System
  def update(delta_time, space, app)
    space.entities.select { |e| e[KeyInputComponent]? && e[VelocityComponent]? }.each do |e|
      vel = e[VelocityComponent]

      new_vel_y = 0f32
      new_vel_y += -800f32 if app.key_pressed?(Glove::Key::KEY_DOWN)
      new_vel_y += 800f32 if app.key_pressed?(Glove::Key::KEY_UP)

      vel.y = 0.3f32 * new_vel_y + 0.7f32 * vel.y
    end
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

####

class FollowComponent < Glove::Component
  getter :followee
  getter :offset

  def initialize(@followee : Glove::Entity, @offset : Glove::Vector)
  end
end

class FollowSystem < Glove::System
  def update(delta_time, space, app)
    space.entities.all_with_component(FollowComponent).each do |e|
      followee = e[FollowComponent].followee

      e[Glove::Components::Transform].translate_x =
        followee[Glove::Components::Transform].translate_x +
        e[FollowComponent].offset.dx

      e[Glove::Components::Transform].translate_y =
        followee[Glove::Components::Transform].translate_y +
        e[FollowComponent].offset.dy
    end
  end
end

####

class LootComponent < Glove::Component
end

class LootDespawnerSystem < Glove::System
  def update(delta_time, space, app)
    x = player_x(space)

    space.entities.all_with_component(LootComponent).each do |e|
      if t = e[Glove::Components::Transform]?
        if t.translate_x < x - 200
          e.dead = true
        end
      end
    end
  end

  private def player_x(space)
    player = space.entities.all_with_component(PlayerComponent)[0]
    player[Glove::Components::Transform].translate_x
  end
end

class LootSpawnerSystem < Glove::System
  def initialize
    @time_total = 0f32
    @time_until_next = 0f32
    @drop_every = 1f32
    @speed = -300f32
  end

  def update(delta_time, space, app)
    @speed = {-1500f32, -100f32 - @time_total * 10}.max
    @drop_every = 2 * Math::PI.to_f32/2f32 + 0.1f32 - Math.atan(@time_total / 20) * 2

    @time_total += delta_time
    @time_until_next += delta_time

    if @time_until_next > @drop_every
      @time_until_next -= @drop_every
      spawn_loot(space)
    end
  end

  private def spawn_loot(space)
    space.entities <<
      Glove::Entity.new.tap do |e|
        e << Glove::Components::Color.new(Glove::Color.new(1f32, 0f32, 0f32, 0.5f32))
        e << Glove::Components::Z.new(15.0_f32)
        e << VelocityComponent.new(@speed, 0f32)
        e << LootComponent.new
        e << Glove::Components::Transform.new.tap do |t|
          t.width = 30_f32
          t.height = 30_f32
          t.anchor_x = 0.5_f32
          t.anchor_y = 0.5_f32
          t.translate_x = player_x(space) + 1000f32
          t.translate_y = (Random.rand.to_f32 * 2f32 - 1f32) * 200f32
        end
      end
  end

  private def player_x(space)
    player = space.entities.all_with_component(PlayerComponent)[0]
    player[Glove::Components::Transform].translate_x
  end
end

####

class ConstrainedMovementComponent < Glove::Component
  getter :min_y
  getter :max_y

  # TODO: do the same for X
  def initialize(@min_y : Float32, @max_y : Float32)
  end
end

class ConstrainedMovementSystem < Glove::System
  def update(delta_time, space, app)
    space.entities.all_with_component(ConstrainedMovementComponent).each do |e|
      cm = e[ConstrainedMovementComponent]
      if t = e[Glove::Components::Transform]?
        t.translate_y = cm.max_y if t.translate_y > cm.max_y
        t.translate_y = cm.min_y if t.translate_y < cm.min_y
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

player =
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Color.new(Glove::Color.new(0f32, 0f32, 0f32, 0.5f32))
    e << Glove::Components::Z.new(15.0_f32)
    e << PlayerComponent.new
    e << KeyInputComponent.new
    e << VelocityComponent.new(100.0f32, 0.0f32)
    e << ConstrainedMovementComponent.new(-190f32, 190f32)
    e << Glove::Components::Transform.new.tap do |t|
      t.width = 30_f32
      t.height = 100_f32
      t.anchor_x = 0.5_f32
      t.anchor_y = 0.5_f32
    end
  end

camera =
  Glove::Entity.new.tap do |e|
    e << Glove::Components::Camera.new
    e << Glove::Components::Z.new(10.0_f32)
    e << FollowComponent.new(player, Glove::Vector.new(470f32, 0f32))
    e << ConstrainedMovementComponent.new(0f32, 0f32)
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
      space.entities << sky_distant
      space.entities << sky_close
      space.entities << player
      space.entities << camera

      space.systems << KeyInputSystem.new
      space.systems << UpdatePositionSystem.new
      space.systems << SkySystem.new
      space.systems << LootSpawnerSystem.new
      space.systems << LootDespawnerSystem.new
      space.systems << FollowSystem.new
      space.systems << ConstrainedMovementSystem.new
    end
  end

app.replace_scene(scene)
app.run
