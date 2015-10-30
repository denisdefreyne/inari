class RemoveFromVisibleCardsAction < Glove::InstantAction
  def initialize(@entity : Glove::Entity)
    super()
  end

  def update(_delta_time)
    @entity.delete_component(VisibleComponent.sym)
  end
end

class KillAction < Glove::InstantAction
  def initialize(@entity : Glove::Entity)
    super()
  end

  def update(_delta_time)
    @entity.dead = true
  end
end

class RestartAction < Glove::InstantAction
  def initialize(@app)
    super()
  end

  def update(_delta_time)
    @app.scene.entities << EntityFactory.new_quitter
    @app.scene.entities << EntityFactory.new_cursor
    @app.scene.entities << EntityFactory.new_camera

    CardGenerator.new_combination.each_with_index do |tuple, idx|
      entity = EntityFactory.new_card(tuple[0], tuple[1], idx)
      @app.scene.entities << entity

      x_offset = idx * 3
      new_x = (idx % 6)      * 150_f32 - x_offset
      new_y = (idx / 6).to_i * 200_f32

      @app.scene.actions << Glove::Actions::Sequence.new(
        [
          Glove::Actions::Delay.new(entity, 0.2_f32 + (18 - idx) / 10_f32),
          Glove::Actions::MoveBy.new(entity, new_x, new_y, 0.5_f32),
        ]
      )
    end
  end
end
