require 'yaml'

class Recipe
  DEFALUT_FILE_PATH = 'src/recipes.yml'.freeze

  def all
    recipes
  end

  def all_with_id
    if exist_recipe_id?
      recipe_by_id(recipe_id)
    else
      recipes.map.with_index(1) { |recipe, i| "#{i}: #{recipe}" }
    end
  end

  private

  def recipes
    @recipes ||= load_recipe_file
  end

  def recipe_size
    recipes.size
  end

  def recipe_by_id(id)
    recipes[id]
  end

  def recipe_id
    ARGV[1].to_i - 1 if valid_recipe_id?
  end

  def valid_recipe_id?
    ARGV[1].to_i > 0 or raise "#{ARGV[1]} is not valid id"
  end

  def exist_recipe_id?
    !!ARGV[1]
  end

  def load_recipe_file
    YAML.load_file(recipe_file_path) if exist_recipe_file?
  end

  def exist_recipe_file?
    File.exist?(recipe_file_path) or raise "#{recipe_file_path} does not exist."
  end

  def recipe_file_path
    @recipe_file_path ||= (ARGV[0] || DEFALUT_FILE_PATH)
  end
end

# puts Recipe.new.all
puts Recipe.new.all_with_id
