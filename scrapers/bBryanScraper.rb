require "httparty"
require "nokogiri"

# Struct to store animal in list
Animal = Struct.new(:animal_name)

def getBBryanPreserveAnimals()

	response = HTTParty.get("https://www.bbryanpreserve.com/the-animals")
	document = Nokogiri::HTML(response.body)

	bBryanAnimals = []

	# block to get animals from grid:
	html_grid_animals = document.css("a.summary-title-link")

	html_grid_animals.each do |html_grid_animal|
		animal_name = html_grid_animal.text.strip
		animal = Animal.new(animal_name)
		bBryanAnimals.push(animal)
	end

	zoo_to_animals_map = Hash.new
	zoo_to_animals_map = {"B Bryan Preserve" => bBryanAnimals}
	return zoo_to_animals_map
end