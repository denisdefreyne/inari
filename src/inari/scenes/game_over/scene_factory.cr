module SceneFactory
  def self.new_game_over_scene
    Glove::Scene.new.tap do |scene|
      scene.spaces << Glove::Space.new.tap do |space|
        # TODO: Also add the score here

        space.entities << EntityFactory.new_victory_background
        space.entities << EntityFactory.new_cursor
        space.entities << EntityFactory.new_play_again_button
        space.entities << EntityFactory.new_quit_button
      end
    end
  end
end
