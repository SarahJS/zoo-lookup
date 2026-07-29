require "httparty"
require "nokogiri"

# Struct to store animal in list
Animal = Struct.new(:animal_name)

def getReidParkZooAnimals()

	response = HTTParty.get("https://reidparkzoo.org/animals/")
	document = Nokogiri::HTML(response.body)

	reidParkAnimals = []

	html_grid_animals = document.css("ul").css("li")
	# puts html_grid_animals

	html_grid_animals.each do |html_grid_animal|
		animal_name = html_grid_animal.css("h3").text
		# puts animal_name.length

		# put scraped data in animal struct
		if animal_name.length > 0
			animal = Animal.new(animal_name)
			reidParkAnimals.push(animal)
		end
	end

	zoo_to_animals_map = Hash.new
	zoo_to_animals_map = {"B Bryan Preserve" => reidParkAnimals}
	return zoo_to_animals_map

end