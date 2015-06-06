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
      formatted_recipes = recipes.map { |recipe| "#{recipe.id}: #{recipe.name}" }

      all_recipes_or_specific_recipe(formatted_recipes)
    end

    def all_items_with_id_and_url
      formatted_recipes = recipes.map { |recipe| "#{recipe.id}: #{recipe.name} #{recipe.url}" }

      all_recipes_or_specific_recipe(formatted_recipes)
    end

    private

    def all_recipes_or_specific_recipe(recipes)
      has_recipe_id? ? recipes[recipe_id] : recipes
    end

    def recipes
      @recipes ||= load_recipe
    end

    def recipe_size
      recipes.size
    end

    def load_recipe
      load_recipe_file.map.with_index(1) do |recipe, i|
        recipe_attributes = recipe.merge(id: i)
        Recipes::Item.new(recipe_attributes)
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

    def valid_recipe_id?
      has_recipe_id? && (ARGV[1].to_i > 0 && ARGV[1].to_i <= recipe_size)
    end

    def has_recipe_id?
      !!ARGV[1]
    end

    def recipe_id
      @recipe_id ||= begin
        raise "#{ARGV[1]} is not valid id" unless valid_recipe_id?
        ARGV[1].to_i - 1
      end
    end
  end
end
