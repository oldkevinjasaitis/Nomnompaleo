class Nomnompaleo::CLI

    attr_accessor :exit, :recipe, :month
  
    SEPARATOR = "---------------------------------------------------"
  
    def initialize
      @exit = false
    end
  
    def call
      self.user_interface
    end
  
    def user_interface
      inner_menu_flag = false
      puts SEPARATOR
      self.greeting
      puts SEPARATOR
      self.list_month_recipes
      puts SEPARATOR
      self.select_recipe
      self.show_recipe_summary
      while !self.exit
        puts SEPARATOR
        inner_menu_flag ? self.inner_menu : self.menu
        print "> ".colorize(:red)
        case input = gets.chomp.downcase
        when "main"
          inner_menu_flag = false
          puts SEPARATOR
          self.list_month_recipes
          puts SEPARATOR
          self.recipe = nil
          self.select_recipe unless exit
          self.show_recipe_summary unless exit
        when "prep"
          if !(exit || Nomnompaleo::Recipe.all.empty?)
            puts SEPARATOR
            self.show_ingredients_and_prep
            inner_menu_flag = true
          end
        when "exit"
          self.exit = true
        end
      end
      puts SEPARATOR
      puts "Thank you for using Nomnompaleo, stay awesome!"
      puts SEPARATOR
    end
  
    def greeting
      puts "Welcome to Nomnompaleo. here are some of the best paleo recipes out there."
      puts "Information from: nomnompaleo.com!"
    end
  
    def menu
      puts "Type 'prep' to get cooking!"
      puts "Type 'main' to go back to the beginning."
      puts "Type 'exit' to quit the program."
    end
  
    def inner_menu
      puts "Type main to go back to the beginning."
      puts "Type exit to quit the program."
    end
  
    def get_ingredients_and_prep
      scrapy = Nomnompaleo::Scraper.scrape_by_recipe(self.recipe)
      scrapy.add_ingredients
      scrapy.add_prep
      scrapy.add_prep_notes
    end
  
    def show_ingredients_and_prep
      self.get_ingredients_and_prep
      self.show_ingredients
      self.show_prep
      self.show_prep_notes
    end
  
    def show_ingredients
      puts "Ingredients:"
      puts SEPARATOR
      self.recipe.ingredients.each.with_index(1) do |ing, i|
        print "#{i}. "
        ing.each do |k, v|
          print "#{v} " unless v == ""
        end
        puts ""
      end
      puts SEPARATOR
    end
  
    def show_prep
      puts "Instructions:"
      puts SEPARATOR
      self.recipe.prep_steps.each.with_index(1) {|step, i| puts "#{i}. #{step}"}
      puts SEPARATOR
    end
  
    def show_prep_notes
      puts "Notes:"
      puts SEPARATOR
      self.recipe.prep_notes.each.with_index(1) {|note, i| puts "#{i}. #{note}"}
      puts SEPARATOR
    end
  
    def show_recipe_summary
      if !self.recipe.nil?
        self.get_description
        puts "Name:"
        puts self.recipe.name
        puts "Description:"
        puts self.recipe.description
      end
    end
  
    def list_month_recipes
      self.month = nil
      puts "Please select a month in 2021 to find the recipes for that month using this example (2021/XX) X being 01-12"
      bad_month = true
      while bad_month && !self.exit
        print "> ".colorize(:green)
        input = gets.chomp
        if input.match?(/2021\/\d/)
          self.month = input
          puts "Recipes for this month are:"
          puts SEPARATOR
          self.get_month_recipes
          bad_month = false
        elsif input == "exit"
         self.exit = true
        else
          puts "Please enter a valid month"
        end
      end
    end
  
    def select_recipe  #sets recipe to an instance
      if !Nomnompaleo::Recipe.all.empty?
        selection = nil
        puts "Please enter the number of the recipe you wish to get more details: (or type exit)"
        bad_number = true
        while bad_number && !self.exit
          print "> ".colorize(:red)
          selection = gets.chomp
          puts SEPARATOR
          if selection.to_i > 0 && selection.to_i <= Nomnompaleo::Recipe.all.size  #maybe can abstract it more?
            bad_number = false
            self.recipe = Nomnompaleo::Recipe.all[selection.to_i - 1]
          elsif selection == "exit"
            self.exit = true
          else
            puts "Please enter a valid selection:"
          end
        end
      end
    end
  
    def get_description
      self.recipe.description = Nomnompaleo::Scraper.scrape_by_recipe(self.recipe).add_description
    end
  
    def get_month_recipes
      Nomnompaleo::Recipe.reset_all
      Nomnompaleo::Scraper.create_by_month(self.month).create_recipes
      Nomnompaleo::Recipe.all.each.with_index(1) do |recipe, index|
        puts "#{index}. #{recipe.name}"
      end
    end
  
  end
  
