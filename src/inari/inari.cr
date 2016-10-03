require "glove"

require "./components"
require "./actions"
require "./entity_factory"
require "./event_handlers"
require "./scenes"

module CardGenerator
  def self.new_combination
    suits = {"Clubs", "Diamonds", "Hearts", "Spades"}
    ranks = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"}

    combinations = [] of Tuple(String, String)
    suits.each { |s| ranks.each { |r| combinations << {s, r} } }
    combinations.shuffle!

    (combinations.first(9) * 2).shuffle
  end
end

game = Glove::EntityApp.new(950, 650, "Inari")
game.clear_color = Glove::Color::WHITE
game.replace_scene(SceneFactory.new_start_scene)
game.run
