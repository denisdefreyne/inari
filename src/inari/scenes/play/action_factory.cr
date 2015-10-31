module ActionFactory
  def self.new_shake(camera)
    Glove::Actions::Sequence.new(
      [
        Glove::Actions::Delay.new(0.33_f32),
        Glove::Actions::MoveBy.new(camera, 4_f32, 0_f32, 0.05_f32),
        Glove::Actions::MoveBy.new(camera, -8_f32, 0_f32, 0.05_f32),
        Glove::Actions::MoveBy.new(camera, 8_f32, 0_f32, 0.05_f32),
        Glove::Actions::MoveBy.new(camera, -8_f32, 0_f32, 0.05_f32),
        Glove::Actions::MoveBy.new(camera, 8_f32, 0_f32, 0.05_f32),
        Glove::Actions::MoveBy.new(camera, -4_f32, 0_f32, 0.05_f32),
      ]
    )
  end

  def self.new_celebrate(camera)
    Glove::Actions::Sequence.new(
      [
        Glove::Actions::Delay.new(0.33_f32),
        Glove::Actions::ScaleTo.new(camera, 1.1_f32, 1.1_f32, 0.12_f32),
        Glove::Actions::ScaleTo.new(camera, 1_f32,   1_f32,   0.12_f32),
        Glove::Actions::ScaleTo.new(camera, 1.1_f32, 1.1_f32, 0.12_f32),
        Glove::Actions::ScaleTo.new(camera, 1_f32,   1_f32,   0.12_f32),
      ]
    )
  end

  def self.new_flip_card(entity, new_texture)
    Glove::Actions::Spawn.new(
      [
        Glove::Actions::ScaleTo.new(entity, 1_f32, 1_f32, 1_f32),
        Glove::Actions::Sequence.new(
          [
            # FIXME: Having to specify an explicit duration is icky.
            Glove::Actions::Delay.new(0.23_f32),
            Glove::Actions::ChangeTexture.new(entity, new_texture),
          ]
        )
      ]
    )
  end

  def self.new_flip_card_back(entity)
    Glove::Actions::Sequence.new(
      [
        Glove::Actions::Delay.new(0.7_f32),
        Glove::Actions::Spawn.new(
          [
            Glove::Actions::ScaleTo.new(entity, -1_f32, 1_f32, 1_f32),
            Glove::Actions::Sequence.new(
              [
                # FIXME: Having to specify an explicit duration is icky.
                Glove::Actions::Delay.new(0.23_f32),
                Glove::Actions::ChangeTexture.new(entity, "assets/playing-cards/cardBack_blue4.png"),
                RemoveFromVisibleCardsAction.new(entity),
              ]
            )
          ]
        )
      ]
    )
  end

  def self.new_remove_card(entity)
    Glove::Actions::Sequence.new(
      [
        Glove::Actions::Delay.new(0.7_f32),
        Glove::Actions::Spawn.new(
          [
            Glove::Actions::ScaleTo.new(entity, 0_f32, 0_f32, 0.7_f32),
            Glove::Actions::RotateBy.new(entity, 10_f32, 0.8_f32),
          ]
        ),
        Glove::Actions::Kill.new(entity),
        RemoveFromVisibleCardsAction.new(entity),
      ]
    )
  end
end
