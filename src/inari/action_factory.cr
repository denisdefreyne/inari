module ActionFactory
  def self.new_shake(camera)
    if Random.rand < 0.5
      Glove::ActionSequence.new(
        [
          Glove::DelayAction.new(camera, 0.33_f32),
          Glove::RotateAction.new(camera, 0.1_f32, 0.10_f32),
          Glove::RotateAction.new(camera, -0.2_f32, 0.10_f32),
          Glove::RotateAction.new(camera, 0.1_f32, 0.10_f32),
        ]
      )
    else
      Glove::ActionSequence.new(
        [
          Glove::DelayAction.new(camera, 0.33_f32),
          Glove::MoveAction.new(camera, 4_f32, 0_f32, 0.05_f32),
          Glove::MoveAction.new(camera, -8_f32, 0_f32, 0.05_f32),
          Glove::MoveAction.new(camera, 8_f32, 0_f32, 0.05_f32),
          Glove::MoveAction.new(camera, -8_f32, 0_f32, 0.05_f32),
          Glove::MoveAction.new(camera, 8_f32, 0_f32, 0.05_f32),
          Glove::MoveAction.new(camera, -4_f32, 0_f32, 0.05_f32),
        ]
      )
    end
  end

  def self.new_celebrate(camera)
    Glove::ActionSequence.new(
      [
        Glove::DelayAction.new(camera, 0.33_f32),
        Glove::ScaleAction.new(camera, 1.1_f32, 1.1_f32, 0.12_f32),
        Glove::ScaleAction.new(camera, 1_f32,   1_f32,   0.12_f32),
        Glove::ScaleAction.new(camera, 1.1_f32, 1.1_f32, 0.12_f32),
        Glove::ScaleAction.new(camera, 1_f32,   1_f32,   0.12_f32),
      ]
    )
  end

  def self.new_flip_card(entity, new_texture)
    Glove::SpawnAction.new(
      [
        Glove::ScaleAction.new(entity, 1_f32, 1_f32, 1_f32),
        Glove::ActionSequence.new(
          [
            # FIXME: Having to specify an explicit duration is icky.
            Glove::DelayAction.new(entity, 0.23_f32),
            Glove::ChangeTextureAction.new(entity, new_texture),
          ]
        )
      ]
    )
  end

  def self.new_flip_card_back(entity)
    Glove::ActionSequence.new(
      [
        Glove::DelayAction.new(entity, 0.7_f32),
        Glove::SpawnAction.new(
          [
            Glove::ScaleAction.new(entity, -1_f32, 1_f32, 1_f32),
            Glove::ActionSequence.new(
              [
                # FIXME: Having to specify an explicit duration is icky.
                Glove::DelayAction.new(entity, 0.23_f32),
                Glove::ChangeTextureAction.new(entity, "assets/playing-cards/cardBack_blue4.png"),
                RemoveFromVisibleCardsAction.new(entity),
              ]
            )
          ]
        )
      ]
    )
  end

  def self.new_remove_card(entity)
    Glove::ActionSequence.new(
      [
        Glove::DelayAction.new(entity, 0.7_f32),
        Glove::SpawnAction.new(
          [
            Glove::ScaleAction.new(entity, 0_f32, 0_f32, 0.7_f32),
            Glove::RotateAction.new(entity, 10_f32, 0.8_f32),
          ]
        ),
        KillAction.new(entity),
        RemoveFromVisibleCardsAction.new(entity),
      ]
    )
  end
end
