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

  def handle(event, entity, scene)
    if event.pressed?
      visible_cards = scene.entities.find(VisibleComponent)

      return if visible_cards.size >= 2
      return if visible_cards.includes?(entity)

      transform = entity.transform
      return unless transform

      if transform.scale_x > 0_f32
        scene.actions << ActionFactory.new_flip_card_back(entity)
      else
        entity << VisibleComponent.new
        new_texture = front_texture_for(entity)
        scene.actions << ActionFactory.new_flip_card(entity, front_texture_for(entity))
      end

      visible_cards = scene.entities.find(VisibleComponent)
      if visible_cards.size == 2
        if cards_identical?(visible_cards[0], visible_cards[1])
          if camera = scene.entities.find(Glove::Components::Camera).first
            scene.actions << ActionFactory.new_celebrate(camera)
          end

          visible_cards.each do |entity|
            scene.actions << ActionFactory.new_remove_card(entity)
          end

          if scene.entities.find(CardTypeComponent).size <= 2
            scene.actions << Glove::Actions::Sequence.new(
              [
                Glove::Actions::Delay.new(1_f32),
                RestartAction.new(scene),
              ]
            )
          end
        else
          if camera = scene.entities.find(Glove::Components::Camera).first
            scene.actions << ActionFactory.new_shake(camera)
          end

          visible_cards.each do |entity|
            scene.actions << ActionFactory.new_flip_card_back(entity)
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

scene = Glove::Scene.new
scene.actions << RestartAction.new(scene)

game.scene = scene
game.run
