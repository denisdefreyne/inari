module SceneFactory
  def self.new_pause_scene
    Glove::Scene.new.tap do |scene|
      scene.spaces << Glove::Space.new.tap do |space|
        space.entities << EntityFactory.new_cursor
        space.entities << EntityFactory.new_pause_scene_event_handler
        space.entities << EntityFactory.new_resume_button
        space.entities << EntityFactory.new_quit_button
      end
    end
  end
end
