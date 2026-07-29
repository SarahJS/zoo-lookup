require_relative "birminghamAlScraper"
require_relative "bBryanScraper"
require_relative "reidParkScraper"

listOfMaps = []

birminghamZooAnimalsMap = getBirminghamZooAnimals
bBryanScraperAnimalsMap = getBBryanPreserveAnimals
reidParkZooAnimalsMap = getReidParkZooAnimals

listOfMaps.push(birminghamZooAnimalsMap, bBryanScraperAnimalsMap, reidParkZooAnimalsMap)

animalToZooMap = Hash.new

# foreach map in the list of zoo -> animals map
listOfMaps.each do |zoo2Animal|
	# get the key value pair.
	zooName, animalsList = zoo2Animal.first
	zoosContainingAnimal = [zooName]
	# puts "zoos containing animal outer loop " + zoosContainingAnimal.join(', ')
	# for each species in the animals list
	animalsList.each do |animalSpecies|
		# if the animalToZoo map *doesn't* contain the animal, add it and the value to the map.
		# puts "zoos containing animal inner loop " + zoosContainingAnimal.join(', ')
		if !animalToZooMap.key?(animalSpecies.animal_name)
			animalToZooMap[animalSpecies.animal_name] = zoosContainingAnimal
		else
			# otherwise, modify the list of zoos containing that animal, and update the hash.
			puts "we should never get here"
			zoosContainingAnimal = animalToZooMap[animalSpecies.animal_name] + [zooName]
			animalToZooMap[animalSpecies.animal_name] = zoosContainingAnimal
		end
	end
end