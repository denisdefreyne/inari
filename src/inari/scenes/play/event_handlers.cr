struct PlaySceneEventHandler < Glove::EventHandler
  def handle(event, entity, space, app)
    case event
    when Glove::Events::Key
      if event.pressed?
        if event.key == Glove::Key::KEY_ESCAPE
          app.push_scene(SceneFactory.new_pause_scene)
        end
      end
    end
  end
end


struct CardMouseEventHandler < Glove::EventHandler
  private def front_texture_for(entity)
    if card_type = entity[CardTypeComponent]
      "assets/playing-cards/card#{card_type.string}.png"
    else
      "assets/playing-cards/cardBack_red1.png"
    end
  end

  private def cards_identical?(entity_0, entity_1)
    entity_0[CardTypeComponent].string == entity_1[CardTypeComponent].string
  end

  def handle(event, entity, space, app)
    case event
    when Glove::Events::MousePressed
      visible_cards = space.entities.all_with_component(VisibleComponent)

      scorer = space.entities.all_with_component(ScoringComponent)[0]
      scorer[ScoringComponent].record_click

      return if visible_cards.size >= 2
      return if visible_cards.includes?(entity)

      transform = entity[Glove::Components::Transform]
      return unless transform

      if transform.scale_x > 0_f32
        space.actions << ActionFactory.new_flip_card_back(entity)
      else
        entity << VisibleComponent.new
        new_texture = front_texture_for(entity)
        space.actions << ActionFactory.new_flip_card(entity, front_texture_for(entity))
      end

      visible_cards = space.entities.all_with_component(VisibleComponent)
      if visible_cards.size == 2
        if cards_identical?(visible_cards[0], visible_cards[1])
          if camera = space.entities.all_with_component(Glove::Components::Camera).first
            space.actions << ActionFactory.new_celebrate(camera)
          end

          all_cards = space.entities.all_with_component(CardTypeComponent)
          num_cards = all_cards.size
          if num_cards <= 4
            all_cards.each do |entity|
              is_visible = visible_cards.includes?(entity)
              space.actions << Glove::Actions::Sequence.new(
                [
                  Glove::Actions::Delay.new(is_visible ? 0_f32 : 1_f32).as(Glove::Action),
                  ActionFactory.new_remove_card(entity, false),
                ]
              )
            end
            space.actions << Glove::Actions::Sequence.new(
              [
                Glove::Actions::Delay.new(3_f32).as(Glove::Action),
                Glove::Actions::ReplaceScene.new(SceneFactory.new_game_over_scene, app),
              ]
            )
          else
            visible_cards.each do |entity|
              space.actions << ActionFactory.new_remove_card(entity)
            end
          end
        else
          if camera = space.entities.all_with_component(Glove::Components::Camera).first
            space.actions << ActionFactory.new_shake(camera)
          end

          visible_cards.each do |entity|
            space.actions << ActionFactory.new_flip_card_back(entity)
          end
        end
      end
    end
  end
end
