require 'yaml'
require 'recipe_tool/recipe'
require 'recipe_tool/user'
require 'recipe_tool/parser'
require 'recipe_tool/recipes_loader'

module RecipeTool
  class Manager
    # deprecate
    def all_recipes
      recipes.map(&:name)
    end

    # deprecate
    def all_recipes_with_id
      formatted_recipes = recipes.map { |recipe| "#{recipe.id}: #{recipe.name}" }

      all_recipes_or_specific_recipe(formatted_recipes)
    end

    def all_recipes_with_user
      if has_recipe_or_user_id?
        recipes_with_user.each do |recipe_with_user|
          if ARGV.size > 3
            if has_recipe_id?
              recipe = recipe_with_user[:recipes].find { |r| r.id == recipe_id }
              recipe_with_user.update(recipes: Array(recipe))
            end

            unless recipe_with_user[:user].id == user_id
              recipe_with_user.update(user_hidden: true)
            end
          else
            recipe = recipe_with_user[:recipes].find { |r| r.id == recipe_id }
            recipe_with_user.update(recipes: Array(recipe))
          end
        end
      end
      recipes_with_user
    end

    private

    def all_recipes_or_specific_recipe(recipes)
      has_recipe_id? ? recipes[recipe_id] : Array(recipes)
    end

    def recipes_with_user
      @recipes_with_user ||= recipes_list.map.with_index do |recipes, i|
        { user: RecipeTool::User.new(user_names && user_names[i], i + 1),
          user_hidden: false,
          recipes: recipes
        }
      end
    end

    def recipes_list
      @recipes ||= load_recipes
    end

    def recipe_size
      recipes_list.flatten.size
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

    # @return [Array<Array<Hash{Symbol => String}>>]
    def load_recipe_files
      recipe_file_paths.map do |recipe_file_path|
        recipes_loader.call(recipe_file_path)
      end
    end

    def recipe_file_paths
      args[:recipe_paths]
    end

    def valid_recipe_id?
      has_recipe_id? && (args[:recipe_id] > 0 && args[:recipe_id] <= recipe_size)
    end

    def has_recipe_id?
      !!args[:recipe_id]
    end

    def recipe_id
      @recipe_id ||= begin
                       raise "#{args[:recipe_id]} is not a valid id" unless valid_recipe_id?
                       args[:recipe_id]
                     end
    end

    def has_user_id?
      !!args[:user_id]
    end

    def user_id
      @user_id ||= args[:user_id]
    end

    def has_user_names?
      !args[:user_names].empty?
    end

    def user_names
      args[:user_names]
    end

    def args
      @args ||= RecipeTool::Parser.new.call
    end

    def has_recipe_or_user_id?
      has_user_id? || has_recipe_id?
    end

    def recipes_loader
      @recipes_loader ||= RecipeTool::RecipesLoader.new
    end
  end
end
