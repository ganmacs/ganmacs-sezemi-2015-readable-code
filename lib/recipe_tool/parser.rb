module RecipeTool
  # recipe args parser

  attr_reader :size

  class Parser
    def initialize(args = ARGV)
      @args = args
      @size = args.size
    end

    def call
      case @size
      when 0                    # not recieve args
        not_recieve_args
      when 1                    # recieve <recipe_path>
        parse_one_args
      when 2                    # recieve <recipe_path> <recipe_id> or <user_name> <recipe_path>
        parse_two_args
      when 3                    # recieve <user_name> <recipe_path> <recipe_id>
        parse_three_args
      else                      # recieve <user_name> <recipe_path> [<user_name> <recipe_path>] [<recipe_id>]
        parse_more_args
      end
    end

    private

    def not_recieve_args
      puts 'Usage: recipe [<recipe_user>] <recipe_file_path> [<recipe_id>]'
      exit(1)
    end

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

    def parse_more_args
      case
      when has_recipe_and_user_id?
        {
          recipe_paths: parse_multi_recipe_and_user[:recipe_paths],
          recipe_id: @args.last.to_i,
          user_names: parse_multi_recipe_and_user[:user_names],
          user_id: @args[-2].to_i
        }
      when has_user_id?
        {
          recipe_paths: parse_multi_recipe_and_user[:recipe_paths],
          user_names: parse_multi_recipe_and_user[:user_names],
          user_id: @args.last.to_i
        }
      else
        {
          recipe_paths: parse_multi_recipe_and_user[:recipe_paths],
          user_names: parse_multi_recipe_and_user[:user_names]
        }
      end
    end

    def parse_multi_recipe_and_user
      h = { user_names: [],
            recipe_paths: [] }

      args
        .each_slice(2)
        .each_with_object(h) do |(user_name, recipe_path), hash|
        hash[:user_names] << user_name
        hash[:recipe_paths] << recipe_path
      end
    end

    def args
      case
      when has_recipe_and_user_id?
        @args[0..-3]
      when has_user_id?
        @args[0..-2]
      else
        @args
      end
    end

    def has_recipe_and_user_id?
      !!Integer(@args[-2]) && !!Integer(@args[-1])
    rescue ArgumentError        # not a number
      false
    end

    def has_user_id?
      !!Integer(@args.last)
    rescue ArgumentError        # not a number
      false
    end

    # call when two args
    def has_recipe_id?
      !!Integer(@args.last)
    rescue ArgumentError        # not a number
      false
    end
  end
end
