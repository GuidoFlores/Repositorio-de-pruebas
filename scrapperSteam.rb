require 'open-uri'
require 'nokogiri'
require 'csv'

class ScrapperSteam
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
    content = parsed_content.css('.home_tabs_content')
    content.css('.tab_content').each do |contents|
    contents.css('.tab_item').each do |games|
      titleGame = games.css('.tab_item_name').inner_text
      price = games.css('.discount_final_price').inner_text
      if price[0]== '$'
        price = price[1,].to_f
      else
        price = 0.0
      end
      discount_block = games.css('.discount_block')
      has_discount = !games.css('.discount_pct').empty?
      genres = games.css('span.top_tag').map(&:text).join("").gsub(",", "")      
      save(file, [titleGame.to_s, price.to_s, has_discount, genres])
    end
    end 
  end
end


scrapper = ScrapperSteam.new('steam.csv')
scrapper.clear('steam.csv')
scrapper.getData('https://store.steampowered.com/')
