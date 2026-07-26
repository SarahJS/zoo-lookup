require "httparty"
require "nokogiri"

response = HTTParty.get("http://birminghamzoo.com/animals/animal-list/")
document = Nokogiri::HTML(response.body)

# Struct to store animal in list
Animal = Struct.new(:animal_name)
animals = []

# block to get animals from grid:
html_grid_animals = document.css("a.animal")

# iterate over list of animals in grid
html_grid_animals.each do |html_grid_animals|
	animal_name = html_grid_animals.css("h4").first.text

	# put scraped data in animal struct
	animal = Animal.new(animal_name)
	animals.push(animal)
end

# block to deal with animals from list:
html_list_animals = document.css("div.animal-list-species")
unordered_html_list_animals = html_list_animals.css("ul").first.css("li")
ordered_html_list_animals = html_list_animals.css("ul").css("li")

ordered_html_list_animals.each do |animal|
	animal_name = animal.text
	animal = Animal.new(animal_name)
	animals.push(animal)
end

# puts animals