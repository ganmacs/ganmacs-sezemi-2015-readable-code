module Recipes
  class Item
    attr_reader :id, :name, :url

    def initialize(id: nil, name: '', url: nil)
      @id = id
      @name = name
      @url = url
    end
  end
end
