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
      visible_cards = space.entities.find(VisibleComponent)

      scorer = space.entities.find(ScoringComponent)[0]
      scorer[ScoringComponent].record_click

      return if visible_cards.size >= 2
      return if visible_cards.includes?(entity)

      transform = entity.transform
      return unless transform

      if transform.scale_x > 0_f32
        space.actions << ActionFactory.new_flip_card_back(entity)
      else
        entity << VisibleComponent.new
        new_texture = front_texture_for(entity)
        space.actions << ActionFactory.new_flip_card(entity, front_texture_for(entity))
      end

      visible_cards = space.entities.find(VisibleComponent)
      if visible_cards.size == 2
        if cards_identical?(visible_cards[0], visible_cards[1])
          if camera = space.entities.find(Glove::Components::Camera).first
            space.actions << ActionFactory.new_celebrate(camera)
          end

          visible_cards.each do |entity|
            space.actions << ActionFactory.new_remove_card(entity)
          end

          if space.entities.find(CardTypeComponent).size <= 2
            space.actions << Glove::Actions::Sequence.new(
              [
                Glove::Actions::Delay.new(1_f32),
                # TODO: Go to “game over” scene instead
                RestartAction.new(space),
              ]
            )
          end
        else
          if camera = space.entities.find(Glove::Components::Camera).first
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
