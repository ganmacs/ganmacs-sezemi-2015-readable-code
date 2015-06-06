require 'yaml'

class Recipe
  DEFALUT_FILE_PATH = 'src/recipes.yml'.freeze

  def all
    recipes
  end

  def all_with_id
    recipes.map.with_index(1) { |recipe, i| "#{i}: #{recipe}" }
  end

  private

  def recipes
    @recipes ||= load_recipe_file
  end

  def load_recipe_file
    YAML.load_file(recipe_file_path)
  end

  def recipe_file_path
    ARGV[0] || DEFALUT_FILE_PATH
  end
end

# puts Recipe.new.all
puts Recipe.new.all_with_id
