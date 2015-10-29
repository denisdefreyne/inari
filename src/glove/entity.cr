class Glove::EntityCollection
  include Enumerable(Glove::Entity)

  def initialize
    @entities = [] of Glove::Entity
  end

  def each
    @entities.each { |e| yield(e) }
  end

  def <<(entity)
    @entities << entity
  end

  def remove_dead
    @entities.reject! { |e| e.dead? }
  end

  def unwrap
    @entities
  end
end

class Glove::Entity
  property :texture
  property :polygon
  property :components
  property :mouse_event_handler
  property :keyboard_event_handler
  property? :dead
  property :tags
  getter :children
  property :z

  def initialize
    @components = [] of Glove::Component
    @components_by_name = {} of Symbol => Glove::Component
    @tags = [] of Symbol
    @children = [] of Glove::Entity
    @z = 0
  end

  def transform
    self[Glove::TransformComponent]?
  end

  def <<(component)
    @components << component
    @components_by_name[component.class.sym] = component
  end

  def [](key)
    @components_by_name[key]
  end

  def []?(key)
    @components_by_name[key]?
  end

  def delete_component(sym : Symbol)
    @components.reject! { |c| c.class.sym == sym }
    @components_by_name.delete(sym)
  end

  def update(delta_time, app)
    components.each { |ul| ul.update(self, delta_time, app) }
  end

  def bounds
    if transform = self.transform
      transform.bounds
    else
      nil
    end
  end
end
