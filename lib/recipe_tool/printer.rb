require 'recipe_tool/manager'

module RecipeTool
  class Printer
    def call
      manager.all_recipes_with_user.each_with_index do |recipe_with_user, i|
        puts "ユーザ: #{i}: #{recipe_with_user[:user_name]}" if recipe_with_user[:user_name]
        recipe_with_user[:recipes].each do |recipe|
          puts "#{recipe.id}: #{recipe.name} #{recipe.url}"
        end

        puts                    # \n
      end
    end

    private

    def manager
      @manager ||= RecipeTool::Manager.new
    end
  end
end
