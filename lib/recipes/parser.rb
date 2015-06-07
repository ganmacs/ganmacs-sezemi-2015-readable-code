module Recipes
  # recipe args parser
  class Parser
    def initialize(args = ARGV)
      @args = args
      @size = args.size
    end

    def args
      case @size
      when 1                    # recieve <recipe_path>
        parse_one_args
      when 2                    # recieve <recipe_path> <recipe_id> or <user_name> <recipe_path>
        parse_two_args
      when 3                    # recieve <user_name> <recipe_path> <recipe_id>
        parse_three_args
      end
    end

    private

    def parse_one_args
      {
        recipe_paths: [@args[0]]
      }
    end

    def parse_two_args
      if has_recipe_id?
        {
          recipe_paths: [@args[0]],
          recipe_id: @args[1].to_i
        }
      else
        {
          recipe_paths: [@args[1]],
          user_names: [@args[0]]
        }
      end
    end

    def parse_three_args
      {
        recipe_paths: [@args[1]],
        recipe_id: @args[2].to_i,
        user_names: [@args[0]]
      }
    end

    def has_recipe_id?
      !!Integer(@args.last)
    rescue ArgumentError        # not a number
      false
    end
  end
end
