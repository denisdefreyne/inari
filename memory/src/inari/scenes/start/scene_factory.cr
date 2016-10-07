module SceneFactory
  def self.new_start_scene
    Glove::Scene.new.tap do |scene|
      scene.spaces << Glove::Space.new.tap do |space|
        space.entities << EntityFactory.new_cursor
        space.entities << EntityFactory.new_play_button
        space.entities << EntityFactory.new_quit_button
      end
    end
  end
end
