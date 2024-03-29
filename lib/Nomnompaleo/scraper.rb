
class Nomnompaleo::Scraper
    attr_accessor :path, :recipe
  
    BASE_PATH = "https://nomnompaleo.com/"
  
    def scrape_main
      begin
        file = open(@path)
        doc = Nokogiri::HTML(file).css("article")
      rescue
        puts "Cannot open URL!"
      end
    end
  
    def create_recipes
      self.scrape_main.each do |node|
        name = node.css(".entry-title").text
        link = node.css("a.entry-title-link").attr("href").value
        recipe = Nomnompaleo::Recipe.new(name, link)
      end unless self.scrape_main.nil?
      !Nomnompaleo::Recipe.all.empty?
    end
  
    def add_description
      self.recipe.description = self.scrape_description.first.children.first.text.gsub!("\u00a0", "")
    end
  
    def scrape_description
      begin
        file = open(self.recipe.link)
        Nokogiri::HTML(file).css(".entry-content p")
      rescue
        puts "Cannot open URL!"
      end
    end
  
    def add_ingredients
      doc = self.scrape_ingredients
        doc.css(".wprm-recipe-ingredient").each do |i|
          ingredient = {}
          ingredient[:amount] = i.css(".wprm-recipe-ingredient-amount").text
          ingredient[:unit] = i.css(".wprm-recipe-ingredient-unit").text
          ingredient[:name] = i.css(".wprm-recipe-ingredient-name").text
          ingredient[:notes] = i.css(".wprm-recipe-ingredient-notes").text
          self.recipe.ingredients << ingredient
        end
    end
  
    def add_prep
      doc = self.scrape_prep
      doc.each do |step|
        self.recipe.prep_steps << step.css("div p").text
      end
      self.recipe.prep_steps.select! {|step| step != ""}
    end
  
    def add_prep_notes
      doc = self.scrape_prep_notes
      doc.each do |note|
        self.recipe.prep_notes << note.text unless note.text.match?(/^\u00a0$/)
      end
      self.recipe.prep_notes.pop
    end
  
    def make_path(month)
     BASE_PATH + month
    end
  
    def self.create_by_month(month = "2021/00")
      scrape = self.new
      scrape.path = scrape.make_path(month)
      scrape
    end
  
    def self.scrape_by_recipe(recipe)
      scrape = self.new
      scrape.recipe = recipe
      scrape
    end
  
    def scrape_ingredients
      begin
        file = open(self.recipe.link)
        Nokogiri::HTML(file).css("recipe-container")
      rescue
        puts "Cannot open URL!"
      end
    end
  
    def scrape_prep
      begin
        file = open(self.recipe.link)
        Nokogiri::HTML(file).css("recipe-instruction")
      rescue
        puts "Cannot open URL!"
      end
    end
  
    def scrape_prep_notes
      begin
        file = open(self.recipe.link)
        Nokogiri::HTML(file).css("recipe-notes-container p")
      rescue
        puts "Cannot open URL!"
      end
    end
  
  end
  
