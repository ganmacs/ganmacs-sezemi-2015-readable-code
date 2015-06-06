require 'yaml'
require 'recipes/item'

module Recipes
  class Manager
    DEFALUT_FILE_PATH = 'src/recipes.yml'.freeze
    VALID_EXTNAME = %w(.yaml .yml).freeze

    def all_items
      recipes.map(&:name)
    end

    def all_items_with_id
      recipes.map { |recipe| "#{recipe.id}: #{recipe.name}" }
    end

    private

    def recipes
      @recipes ||= load_recipe
    end

    def load_recipe
      load_recipe_file.map.with_index(1) do |recipe, i|
        recipe_properties = Array(recipe.split(' '))
        Recipes::Item.new(i, *recipe_properties)
      end
    end

    def load_recipe_file
      raise "#{recipe_file_path} does not exist." unless valid_recipe_file?
      YAML.load_file(recipe_file_path)
    end

    def valid_recipe_file?
      exists_recipe_file? && valid_recipe_extname?
    end

    def exists_recipe_file?
      File.exist?(recipe_file_path)
    end

    def valid_recipe_extname?
      extname = File.extname(recipe_file_path)
      VALID_EXTNAME.include?(extname)
    end

    def recipe_file_path
      @recipe_file_path ||= (ARGV[0] || DEFALUT_FILE_PATH)
    end
  end
end
