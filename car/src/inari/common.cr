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

class RepeatTextureComponent < Glove::Component
end

class RepeatTextureSystem < Glove::System
  def update(delta_time, space, app)
    space.entities.all_with_component(RepeatTextureComponent).each do |entity|
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
          texture_height = transform.height / texture.height

          dx = (ct.translate_x * pf / texture_width + 0.5).floor * texture_width / pf
          dy = (ct.translate_y * pf / texture_height + 0.5).floor * texture_height / pf

          entity[Glove::Components::Transform].translate_x = dx.to_f32
          entity[Glove::Components::Transform].translate_y = dy.to_f32
        end
      end
    end
  end
end

####

class CarComponent < Glove::Component
  property :angle_offset
  property :steer_angle
  property :wheel_dist
  property :velocity

  def initialize(@angle_offset : Float32, @steer_angle : Float32, @wheel_dist : Float32, @velocity : Float32)
  end
end

class KeyInputSystem < Glove::System
  def update(delta_time, space, app)
    space.entities.select { |e| e[CarComponent]? && e[Glove::Components::Transform]? }.each do |e|
      car_c = e[CarComponent]
      tr_c = e[Glove::Components::Transform]

      # steer
      new_steer_angle = 0f32
      if app.key_pressed?(Glove::Key::KEY_LEFT)
        new_steer_angle += 10 * Math::PI.to_f32 * delta_time
      end
      if app.key_pressed?(Glove::Key::KEY_RIGHT)
        new_steer_angle -= 10 * Math::PI.to_f32 * delta_time
      end
      car_c.steer_angle = 0.2f32 * new_steer_angle + 0.8f32 * car_c.steer_angle

      # accelerate
      if app.key_pressed?(Glove::Key::KEY_UP)
        car_c.velocity += 500 * delta_time
      end
      if app.key_pressed?(Glove::Key::KEY_DOWN)
        car_c.velocity -= 500 * delta_time
      end

      # calculate car + wheels position
      pos = Glove::Vector.new(tr_c.translate_x, tr_c.translate_y)
      heading = car_c.angle_offset + tr_c.angle
      pos_front = pos + Glove::Vector.new(car_c.wheel_dist * Math.cos(heading), car_c.wheel_dist * Math.sin(heading))
      pos_back  = pos - Glove::Vector.new(car_c.wheel_dist * Math.cos(heading), car_c.wheel_dist * Math.sin(heading))

      # calculate new car + wheels position and heading
      pos_front += Glove::Vector.new(
        Math.cos(heading + car_c.steer_angle), Math.sin(heading + car_c.steer_angle)) * car_c.velocity * delta_time
      pos_back += Glove::Vector.new(
        Math.cos(heading), Math.sin(heading)) * car_c.velocity * delta_time
      new_pos = (pos_front + pos_back) / 2
      new_heading = Math.atan2(pos_front.dy - pos_back.dy , pos_front.dx - pos_back.dx)

      # update transform
      tr_c.translate_x = new_pos.dx
      tr_c.translate_y = new_pos.dy
      tr_c.angle = new_heading - car_c.angle_offset
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

###

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
