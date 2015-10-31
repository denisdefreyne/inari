class RemoveFromVisibleCardsAction < Glove::InstantAction
  def initialize(@entity : Glove::Entity)
    super()
  end

  def update(_delta_time)
    @entity.delete_component(VisibleComponent.sym)
  end
end

class RestartAction < Glove::InstantAction
  def initialize(@space)
    super()
  end

  def update(_delta_time)
    CardGenerator.new_combination.each_with_index do |tuple, idx|
      entity = EntityFactory.new_card(tuple[0], tuple[1], idx)
      @space.entities << entity

      x_offset = idx * 3
      new_x = (idx % 6)      * 150_f32 - x_offset
      new_y = (idx / 6).to_i * 200_f32

      @space.actions << Glove::Actions::Sequence.new(
        [
          Glove::Actions::Delay.new(0.2_f32 + (18 - idx) / 10_f32),
          Glove::Actions::MoveBy.new(entity, new_x, new_y, 0.5_f32),
        ]
      )
    end
  end
end
