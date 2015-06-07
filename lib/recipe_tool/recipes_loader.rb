require 'yaml'

module RecipeTool
  class RecipesLoader
    DEFALUT_FILE_PATHS = 'src/recipes.yml'.freeze
    VALID_EXTNAME = %w(.yaml .yml).freeze

    # @return [Array<Hash{Symbol => String}>]
    # e.g. [{name: 'カレー', url: 'http://kare.com'}]
    def call(recipe_file_path = nil)
      @recipe_file_path = recipe_file_path
      load_recipes
    end

    private

    def load_recipes
      raise "#{recipe_file_path} is an invalid file" unless valid_recipe_file?
      load_recipe_file
    end

    def load_recipe_file
      YAML.load_file(recipe_file_path)
    end

    def valid_recipe_file?
      exists_recipe_file? && valid_extname?
    end

    def exists_recipe_file?
      File.exist?(recipe_file_path)
    end

    def valid_extname?
      extname = File.extname(recipe_file_path)
      VALID_EXTNAME.include?(extname)
    end

    def recipe_file_path
      @recipe_file_path || DEFALUT_FILE_PATHS
    end
  end
end
