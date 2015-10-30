class Glove::Space
  getter :entities
  getter :actions

  def initialize
    @entities = Glove::EntityCollection.new
    @actions = [] of Glove::Action
  end
end
