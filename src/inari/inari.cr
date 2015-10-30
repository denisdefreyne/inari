require "../glove"

require "./components"
require "./actions"
require "./entity_factory"
require "./action_factory"

struct ClickHandler < Glove::EventHandler
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

  def handle(event, entity, space)
    if event.pressed?
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

module CardGenerator
  def self.new_combination
    suits = {"Clubs", "Diamonds", "Hearts", "Spades"}
    ranks = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"}

    combinations = [] of Tuple(String, String)
    suits.each { |s| ranks.each { |r| combinations << {s, r} } }
    combinations.shuffle!

    (combinations.take(9) * 2).shuffle
  end
end

game = Glove::EntityApp.new(950, 650, "The Game")
game.clear_color = Glove::Color::WHITE

space = Glove::Space.new
space.actions << RestartAction.new(space)

game.spaces << space
game.run
