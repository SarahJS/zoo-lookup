# Zoo Animal Lookup

## Problem
We want to create a site where a user could enter an animal, perhaps from a dropdown or something, and receive a list of all AZA accredited facilities in the United States that house that animal. For example, if I want to visit a zoo that has shoebill storks, they would select "Shoebill Stork", and receive "ZooTampa at Lowry Park" and "The Dallas World Aquarium". In beginning work on the scrapers, I realized that most aquariums do not specify all of the animals they house, so it is likely we will not bother scraping aquariums. Users should assume that lists returned by the api are likely none exhaustive.

## Backend Design
At a high level, the steps we will need to follow to determine which zoos have which animals is:
1. Scrape all possible AZA accredited zoos to determine which zoos are housed there.
2. Store the animal -> zoos relationship in a database.
3. Call an endpoint to query the database for an entered animal.

### Scraper details
One challenge is that zoo websites are not particularly standardized, and there are many AZA accredited facilities in the US. This means that we will need to create so many custom scrapers to populate our db. Code for individual scrapers can be found in the /scrapers directory. For this project we have chosen ruby, mostly because I didn't want to deal with python and I also wanted a language with less boilerplate than java. It is possible that there's a better choice to be made here so I'm open to translating these later if needed.

A handful of scrapers exist already, and they work by just parsing the HTML of a given zoo's website. This approach was taken because as far as I can tell, no zoos in the US provide public APIs, because why would they. I have looked into reverse engineering API endpoints, and may choose this approach for some scrapers going forward, tbd. All of the currently existing scraper scripts return a list of the animals housed at that scrapers' zoo. Meaning that the scrapers currently return a zoo -> animals relationship. Ultimately, because the user of the site will want to see all __zoos__ that house a given __animal__, we will need some way to reformat the results such that an animal is mapped to all available zoos. Details for this will be determined later.

One other thing to consider is that for species conservation reasons, and as a result of the AZAs species survival plans, animals are moved from zoo to zoo with some frequency. For example, Ume the tapir born at Point Defiance Zoo in Tacoma, WA, was recently moved to Minneapolis. This means that the scraper suite cannot just be run once and left forever. We will need to set up some system for running chron jobs. To my knowledge, zoos aren't shipping animals like, every 10 minutes or anything, so probably a monthly or semimonthly cycle should be fine. If we find that this is not sufficiently frequent and lists are too out of date, we can adjust the frequency as needed. I have prior experience with Azkaban for chron jobs, so that is one option, but I am also not married to that. Further research into options is TBD.

### Database Details
#### Options
1. Key values store (ie dynamo)
2. Relational db (ie aurora)
3. NoSQL??
For now, the only thing we want to store is a map from animal -> list of zoos. This makes a key value store like dynamo db an obvious solution. However, in the future we *may* want to store more information, such as identifying details about individial animals at a zoo? Using the Ume example mentioned above, perhaps a user of the site would want to know Ume's birth date, approximate relocation date, family tree, etc. If we choose to expand in this way, we may want to choose a relational db instead. Most zoos do not provide this expanded data on their animal list pages, so to get this information we would probably also have to scrape the zoos' blogs, which adds a lot of work to this project. This consideration doesn't eliminate relational dbs as a consideration. Regarding NoSQL options, further reading is required.

### Endpoints
At the very least we wil need some GET endpoint like /<animal-species> that will query our db table for the specified species, and return the list of zoos.

### Open Questions and TBD:
1. Some zoo websites contain, for example "zebra", while others will list the specific species of zebra. Would these be merged into one "zebra" entry, or should we have 2 more granular entries?
2. Cacheing? Do we care?
3. CDNs? Probably not super necessary but not married to that.
4. Load Balancers? Given that this project will probably have like 5 total users I think we're good, but tbd.
5. Pick a better name/get a URL/Hosting etc.
6. Frontend. This is gonna be really ugly, probably. Also what even are frontend languages.
7. Probably don't want a dropdown since there's like, hundreds of species and scrolling through that will be annoying. Maybe group animals by phylum, or alphabetically, or by native range or optional all of the above.
