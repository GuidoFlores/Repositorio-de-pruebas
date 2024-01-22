require 'open-uri'
require 'nokogiri'
require 'csv'

class ScrapperItchio
  attr_accessor  :file, :url

  def initialize(file) 
    @file = file
  end

  def clear(file)
    CSV.open(file, 'w') do |csv|
    end
  end

  def save(file, data)
    CSV.open(file, 'a') do |csv|
    csv << data
    end
  end

  def getData(url)   
    dataHTML = URI.open(url)
    data = dataHTML.read
    parsed_content = Nokogiri::HTML(data)
    content = parsed_content.css('.game_grid_widget')    
    content.css('.game_cell').each do |games|
      titleGame = games.css('a.title').inner_text
      price = games.css('.price_value').inner_text
      if price[0]== '$'
        price = price[1,].to_f
      else
        price = 0.0
      end
      sale_tag = games.css('.sale_tag')
      has_discount = !sale_tag.empty? && sale_tag.inner_text[sale_tag.inner_text.length - 1]
      genreElement = games.css('.game_genre')
      genre = genreElement.empty? ? "NoGenre" : genreElement.inner_text

      save(file, [titleGame.to_s, price.to_s, has_discount, genre])    
    end 
  end
end


scrapper = ScrapperItchio.new('itchio.csv')
scrapper.clear('itchio.csv')
scrapper.getData('https://itch.io/games/top-sellers')
scrapper.getData('https://itch.io/games/top-sellers?page=2')
scrapper.getData('https://itch.io/games/top-sellers?page=3')
scrapper.getData('https://itch.io/games/top-sellers?page=4')
