module EntityFactory
  def self.new_victory_background
    Glove::Entity.new.tap do |e|
      e << Glove::Components::Texture.new("assets/bg_victory.png")
      e.z = -100
      e << Glove::Components::Transform.new.tap do |t|
        t.width = 950_f32
        t.height = 650_f32
        t.translate_x = 475_f32
        t.translate_y = 325_f32
        t.anchor_x = 0.5_f32
        t.anchor_y = 0.5_f32
      end
    end
  end
end
