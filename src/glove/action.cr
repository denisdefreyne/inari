require "./tween"

abstract class Glove::Action
  abstract def update(delta_time)
  abstract def update_wrapped(delta_time)
end

abstract class Glove::InstantAction < Glove::Action
  def initialize
    @done = false
  end

  def start
  end

  def done?
    @done
  end

  def duration
    0_f32
  end

  def duration_spent
    0_f32
  end

  abstract def update(_delta_time)

  def update_wrapped(delta_time)
    update(delta_time)
    @done = true
  end
end

abstract class Glove::IntervalAction < Glove::Action
  getter :duration
  getter :duration_spent

  def initialize(@duration)
    @duration_spent = 0_f32
  end

  def start
  end

  def done?
    @duration_spent >= @duration
  end

  abstract def update(delta_time)

  def update_wrapped(delta_time)
    if @duration_spent == 0_f32
      start
    end

    update(delta_time)

    @duration_spent += delta_time
  end
end

class Glove::MoveAction < Glove::IntervalAction
  def initialize(@entity : Glove::Entity, dx : Float32, dy : Float32, duration : Float32)
    super(duration)
    @tween = Glove::Tween.new(duration)

    @dx = dx
    @dy = dy

    @x = 1.0_f32
    @y = 1.0_f32
    @new_x = 1.0_f32
    @new_y = 1.0_f32
  end

  def start
    if transform = @entity.transform
      @x = transform.translate_x
      @y = transform.translate_y
      @new_x = @x + @dx
      @new_y = @y + @dy
    end
  end

  def update(delta_time)
    @tween.update(delta_time)
    return if @tween.complete?

    if transform = @entity.transform
      f = @tween.fraction
      transform.translate_x = f * @new_x + (1_f32 - f) * @x
      transform.translate_y = f * @new_y + (1_f32 - f) * @y
    end
  end
end

# TODO: Rename to ScaleTo and add ScaleBy
class Glove::ScaleAction < Glove::IntervalAction
  def initialize(@entity : Glove::Entity, @new_scale_x : Float32, @new_scale_y : Float32, duration : Float32)
    super(duration)
    @tween = Glove::Tween.new(duration)

    @scale_x = 1.0_f32
    @scale_y = 1.0_f32
  end

  def start
    if transform = @entity.transform
      @scale_x = transform.scale_x
      @scale_y = transform.scale_y
    end
  end

  def update(delta_time)
    @tween.update(delta_time)
    return if @tween.complete?

    if transform = @entity.transform
      f = @tween.fraction
      transform.scale_x = f * @new_scale_x + (1_f32 - f) * @scale_x
      transform.scale_y = f * @new_scale_y + (1_f32 - f) * @scale_y
    end
  end
end

class Glove::RotateAction < Glove::IntervalAction
  def initialize(@entity : Glove::Entity, angle_diff : Float32, duration : Float32)
    super(duration)
    @tween = Glove::Tween.new(duration)

    @angle_diff = angle_diff

    @angle = 1.0_f32
    @new_angle = 1.0_f32
  end

  def start
    if transform = @entity.transform
      @angle = transform.angle
      @new_angle = @angle + @angle_diff
    end
  end

  def update(delta_time)
    @tween.update(delta_time)
    return if @tween.complete?

    if transform = @entity.transform
      f = @tween.fraction
      transform.angle = f * @new_angle + (1_f32 - f) * @angle
    end
  end
end

class Glove::ActionSequence < Glove::IntervalAction
  def initialize(@actions)
    duration = @actions.sum(&.duration)
    super(duration)

    @active_index = 0
  end

  def done?
    @active_index >= @actions.size
  end

  def update(delta_time)
    return if @active_index >= @actions.size
    if animation = @actions[@active_index]
      if animation.done?
        @active_index += 1
        update(delta_time)
      else
        animation.update_wrapped(delta_time)
      end
    end
  end
end

class Glove::SpawnAction < Glove::IntervalAction
  def initialize(@actions)
    duration = @actions.map(&.duration).max
    super(duration)
  end

  def update(delta_time)
    @actions.each { |a| a.update_wrapped(delta_time) }
  end
end

class Glove::DelayAction < Glove::IntervalAction
  def initialize(@entity : Glove::Entity, @duration : Float32)
    super(@duration)
  end

  def update(delta_time)
  end
end

class Glove::ChangeZAction < Glove::InstantAction
  def initialize(@entity : Glove::Entity, @new_z : Int32)
    super()
  end

  def update(delta_time)
    @entity.z = @new_z
  end
end

class Glove::ChangeTextureAction < Glove::InstantAction
  def initialize(@entity : Glove::Entity, @texture_path : String)
    super()
    @texture = Glove::AssetManager.instance.texture_from(texture_path)
  end

  def update(delta_time)
    @entity.texture = @texture
  end
end
