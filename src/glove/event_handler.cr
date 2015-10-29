abstract struct Glove::EventHandler
  abstract def handle(event : Glove::Event, entity : Glove::Entity, app)
end
