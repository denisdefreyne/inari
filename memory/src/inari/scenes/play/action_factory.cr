module ActionFactory
  def self.new_shake(camera : Glove::Entity)
    Glove::Actions::Sequence.new(
      [
        Glove::Actions::Delay.new(0.33_f32).as(Glove::Action),
        Glove::Actions::MoveBy.new(camera, 4_f32, 0_f32, 0.05_f32, Glove::Tween::Kind::EaseOut),
        Glove::Actions::MoveBy.new(camera, -8_f32, 0_f32, 0.05_f32, Glove::Tween::Kind::EaseOut),
        Glove::Actions::MoveBy.new(camera, 8_f32, 0_f32, 0.05_f32, Glove::Tween::Kind::EaseOut),
        Glove::Actions::MoveBy.new(camera, -8_f32, 0_f32, 0.05_f32, Glove::Tween::Kind::EaseOut),
        Glove::Actions::MoveBy.new(camera, 8_f32, 0_f32, 0.05_f32, Glove::Tween::Kind::EaseOut),
        Glove::Actions::MoveBy.new(camera, -4_f32, 0_f32, 0.05_f32, Glove::Tween::Kind::EaseOut),
      ]
    )
  end

  def self.new_celebrate(camera : Glove::Entity)
    Glove::Actions::Sequence.new(
      [
        Glove::Actions::Delay.new(0.33_f32).as(Glove::Action),
        Glove::Actions::ScaleTo.new(camera, 1.1_f32, 1.1_f32, 0.12_f32, Glove::Tween::Kind::EaseOut),
        Glove::Actions::ScaleTo.new(camera, 1_f32,   1_f32,   0.12_f32, Glove::Tween::Kind::EaseOut),
        Glove::Actions::ScaleTo.new(camera, 1.1_f32, 1.1_f32, 0.12_f32, Glove::Tween::Kind::EaseOut),
        Glove::Actions::ScaleTo.new(camera, 1_f32,   1_f32,   0.12_f32, Glove::Tween::Kind::EaseOut),
      ]
    )
  end

  def self.new_flip_card(entity : Glove::Entity, new_texture : String)
    Glove::Actions::Spawn.new(
      [
        Glove::Actions::ScaleTo.new(entity, 1_f32, 1_f32, 1_f32, Glove::Tween::Kind::EaseOut).as(Glove::Action),
        Glove::Actions::Sequence.new(
          [
            # FIXME: Having to specify an explicit duration is icky.
            Glove::Actions::Delay.new(0.23_f32).as(Glove::Action),
            Glove::Actions::ChangeTexture.new(entity, new_texture).as(Glove::Action),
          ]
        )
      ]
    )
  end

  def self.new_flip_card_back(entity : Glove::Entity)
    Glove::Actions::Sequence.new(
      [
        Glove::Actions::Delay.new(0.7_f32).as(Glove::Action),
        Glove::Actions::Spawn.new(
          [
            Glove::Actions::ScaleTo.new(entity, -1_f32, 1_f32, 1_f32, Glove::Tween::Kind::EaseOut).as(Glove::Action),
            Glove::Actions::Sequence.new(
              [
                # FIXME: Having to specify an explicit duration is icky.
                Glove::Actions::Delay.new(0.23_f32).as(Glove::Action),
                Glove::Actions::ChangeTexture.new(entity, "assets/playing-cards/cardBack_blue4.png").as(Glove::Action),
                RemoveFromVisibleCardsAction.new(entity).as(Glove::Action),
              ]
            ).as(Glove::Action)
          ]
        ).as(Glove::Action)
      ]
    )
  end

  def self.new_remove_card(entity : Glove::Entity, remove_from_visible = true)
    Glove::Actions::Sequence.new(
      [
        Glove::Actions::Delay.new(0.7_f32).as(Glove::Action),
        Glove::Actions::Spawn.new(
          [
            Glove::Actions::ScaleTo.new(entity, 0_f32, 0_f32, 0.7_f32, Glove::Tween::Kind::EaseOut).as(Glove::Action),
            Glove::Actions::RotateBy.new(entity, 10_f32, 0.8_f32, Glove::Tween::Kind::EaseOut),
            Glove::Actions::Sequence.new(
              [
                Glove::Actions::Delay.new(0.2_f32).as(Glove::Action),
                remove_from_visible ? RemoveFromVisibleCardsAction.new(entity) : Glove::Actions::Delay.new(0_f32),
              ]
            )
          ]
        ),
        Glove::Actions::Kill.new(entity),
      ]
    )
  end
end
