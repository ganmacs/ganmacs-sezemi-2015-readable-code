require 'recipe_tool/manager'
require 'csv'

module RecipeTool
  class CSVPrinter
    def call
      manager.all_recipes_with_user.each do |recipe_with_user|
        user = recipe_with_user[:user]
        recipes = recipe_with_user[:recipes]

        recipes.each do |recipe|
          puts [user.id, user.name, recipe.id, recipe.name, recipe.url].to_csv
        end
      end
    end

    private

    def manager
      @manager ||= RecipeTool::Manager.new
    end
  end
end
