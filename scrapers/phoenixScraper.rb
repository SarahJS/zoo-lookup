require "httparty"
require "nokogiri"

response = HTTParty.get("https://www.phoenixzoo.org/explore/animals/")
document = Nokogiri::HTML(response.body)

Animal = Struct.new(:animal_name)
animals = []

# html_grid_animals = document.css("")