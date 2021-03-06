require 'recipe_tool/manager'

module RecipeTool
  class Printer
    def call
      manager.all_recipes_with_user.each do |recipe_with_user|
        next if recipe_with_user[:user_hidden]

        if recipe_with_user[:user]
          user = recipe_with_user[:user]
          puts "ユーザ: #{user.id}: #{user.name}"
        end

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
