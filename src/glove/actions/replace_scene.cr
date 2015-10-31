class Glove::Actions::ReplaceScene < Glove::InstantAction
  def initialize(@scene, @app)
  end

  def update(delta_time)
    @app.replace_scene(@scene)
  end
end
