require "httparty"
require "nokogiri"

response = HTTParty.get("https://www.bbryanpreserve.com/the-animals")
document = Nokogiri::HTML(response.body)

# Struct to store animal in list
Animal = Struct.new(:animal_name)
animals = []

# block to get animals from grid:
html_grid_animals = document.css("a.summary-title-link")

html_grid_animals.each do |html_grid_animal|
	animal_name = html_grid_animal.text.strip
	animal = Animal.new(animal_name)
	animals.push(animal)
end