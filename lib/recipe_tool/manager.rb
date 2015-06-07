require 'yaml'
require 'recipe_tool/item'
require 'recipe_tool/parser'

module RecipeTool
  class Manager
    DEFALUT_FILE_PATHS = ['src/recipes.yml'].freeze
    VALID_EXTNAME = %w(.yaml .yml).freeze

    # deprecate
    def all_items
      recipes.map(&:name)
    end

    # deprecate
    def all_items_with_id
      formatted_recipes = recipes.map { |recipe| "#{recipe.id}: #{recipe.name}" }

      all_recipes_or_specific_recipe(formatted_recipes)
    end

    def all_items_with_id_and_url
      formatted_recipes = recipes.map do |recipe_list|
        recipe_list.map { |recipe| "#{recipe.id}: #{recipe.name} #{recipe.url}" }
      end

      f = formatted_recipes.map.with_index do |r, i|
        if has_user_names? && user_names[i]
          ["ユーザ名: #{user_names[i]}"] + r
        else
          r
        end
      end
      #                     .map do |recipe|
      #   "#{recipe.id}: #{recipe.name} #{recipe.url}"
      # end

      # puts "ユーザ名: #{user_names.first}" if user_names
      # all_recipes_or_specific_recipe(formatted_recipes)
    end

    private

    def all_recipes_or_specific_recipe(recipes)
      has_recipe_id? ? recipes[recipe_id] : Array(recipes)
    end

    def recipes
      @recipes ||= load_recipes
    end

    def recipe_size
      recipes.size
    end

    # @return [Array<Array<Recipes::Item>>]
    # e.g [[Recipes::Item, Recipes::Item], [Recipes::Item, Recipes::Item]]
    def load_recipes
      i = 1
      load_recipe_files.map do |recipe_file|
        recipe_file.map do |recipe|
          recipe_attributes = recipe.merge(id: i)
          i += 1
          RecipeTool::Recipe.new(recipe_attributes)
        end
      end
    end

    def load_recipe_files
      check_recipe_files_valid
      recipe_file_paths.map { |recipe_file_path| YAML.load_file(recipe_file_path) }
    end

    def check_recipe_files_valid
      recipe_file_paths.each do |recipe_file_path|
        @recipe_file_path = recipe_file_path
        raise "#{recipe_file_path} is an invalid file" unless valid_recipe_file?
      end
    end

    def valid_recipe_file?
      exists_recipe_file? && valid_recipe_extname?
    end

    def exists_recipe_file?
      File.exist?(@recipe_file_path)
    end

    def valid_recipe_extname?
      extname = File.extname(@recipe_file_path)
      VALID_EXTNAME.include?(extname)
    end

    def recipe_file_paths
      @recipe_file_paths ||= (args[:recipe_paths] || DEFALUT_FILE_PATHS)
    end

    def valid_recipe_id?
      has_recipe_id? && (args[:recipe_id] > 0 && args[:recipe_id] <= recipe_size)
    end

    def has_recipe_id?
      !!args[:recipe_id]
    end

    def recipe_id
      @recipe_id ||= begin
                       raise "#{ARGV[1]} is not valid id" unless valid_recipe_id?
                       args[:recipe_id] - 1 # index is start by 1
                     end
    end

    def has_user_names?
      !args[:user_names].empty?
    end

    def user_names
      args[:user_names]
    end

    def args
      @args ||= Parser.new.args
    end
  end
end
