struct ClickEventHandler < Glove::EventHandler
  def initialize(@filename_normal, @filename_hover, @filename_active)
  end

  def handle(event, entity, space, app)
    cursor_tracking = entity[CursorTrackingComponent]?

    case event
    when Glove::Events::CursorEntered
      if cursor_tracking && cursor_tracking.pressed?
        entity.texture = Glove::AssetManager.instance.texture_from(@filename_active)
      else
        entity.texture = Glove::AssetManager.instance.texture_from(@filename_hover)
      end
    when Glove::Events::CursorExited
      entity.texture = Glove::AssetManager.instance.texture_from(@filename_normal)
    when Glove::Events::MousePressed
      if cursor_tracking
        cursor_tracking.pressed = true
      end
      entity.texture = Glove::AssetManager.instance.texture_from(@filename_active)
    when Glove::Events::MouseReleased
      if cursor_tracking
        if cursor_tracking.pressed? && cursor_tracking.inside?
          if on_click_component = entity[OnClickComponent]?
            on_click_component.proc.call(entity, event, space, app)
            entity.texture = Glove::AssetManager.instance.texture_from(@filename_hover)
          end
        end
        cursor_tracking.pressed = false
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
