module SceneFactory
  def self.new_play_scene
    Glove::Scene.new.tap do |scene|
      scene.spaces << Glove::Space.new.tap do |main_space|
        main_space.entities << EntityFactory.new_play_scene_event_handler
        main_space.entities << EntityFactory.new_cursor
        main_space.entities << EntityFactory.new_camera
        main_space.entities << EntityFactory.new_scorer
        main_space.actions << RestartAction.new(main_space)
      end

      scene.spaces << Glove::Space.new.tap do |ui_space|
      end
    end
  end
end
