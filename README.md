# IMDbehind the Scenes
## Team members 
A Project Jonatan Kunze, Alexander Link, René Maier

## Used visualization techniques
- Map in http://localhost:5173/Map
- Pie Chart in http://localhost:5173/pie
- Stacked Histogram in http://localhost:5173/events
- Population Pyramid in http://localhost:5173/populationPyramid

## Source of Data
https://datasets.imdbws.com/
## Source of Code
https://svelte.dev/
https://d3js.org/

To find the source code for each individual page, navigate to ./VISHCI/HCI/src/routes/ to the folders events, Map, pie, orpopulationPyramid

# How to get it running
## Prerequisites:
- Docker (https://docs.docker.com/get-docker/)
- Node.js (https://nodejs.org/en/download/package-manager)

We used the following Versions:
- Docker Desktop 4.30.0.0
- Node.js 20.14.0 including npm 10.7.0

## Instructions
After cloning the repository, clone the needed docker container (NOTE: this may take a while):
``` bash
docker run --name Db-Container -d -p 5432:5432 landstreicherjo/hci:latest
```
After the Container is installed, it will init the database automatically. This will take a few minutes the first time it's launched.
When it is done, it will say "database system is ready to accept connections" in the logs. These logs may be viewed with docker-desktop, lazydocker or the following command:
``` bash
 docker logs -f Db-Container
```

When the Container is running, navigate into the ./VISHCI/HCI Folder using a terminal

Install dependencies using npm
```bash
npm install
```
And run the project
```bash
npm run dev -- --open
```
A Website should open (localhost:5173). The home page contains an AI generated Image and the title of the project.

Navigation to the four visualization parts is via the header. Svelte queries the database before loading the site, which may take a few seconds
Should an internal Server error occur, a refresh of the site is usually enough to fix it. This can be due to little available RAM.

## Explanation of each site
### Country Movie Ratings
A World map, where every Country gets colored according to the average rating of movies made in that country in the given timeframe.

Good average Ratings (6 and higher) are green, while bad average ratings (below 6) are red. The darker the hue, the better/worse the rating gets

The sliders "minYear" and "MaxYear" restrict the used movies to the given timeframe.
The selection for "Filter Adult Films" are:
- All Films: Consider all film genres when calculating the average
- Only Adult Films: Only consider movies which have the boolean 'isAdult' set to true. In other words, only consider porn-movies
- No Adult Films:Only consider movies which have the boolean 'isAdult' set to false. In other words, only consider non-porn-movies

Hovering over a country will show a tooltip, which shows the country name, the average rating for the country and the numbers of films used in the calculation.
### Genres Timeline
A stacked histogram, which shows the amount of genres of movies in a given year.

The "Select Historical Event" shows a selection of historical events. Choosing one event narrows the field of view to the year of the event +- five years

The "Show absolute Values" and "Show Relative Values" relate to how the number of genres should be represented.

Hovering over the histogram yields a tooltip, showing the year under the cursor, as well as the amount of genres of movies made in that year

Hovering over a genre on the legend will highlight the selected genre on the histogram

### Living Actors
A Bar Chart to show the relative distribution of genders in living actors.
NOTE: The database does not have a gender in its schema, however, actors and actresses are treated as separate professions, which allows filtering for male actors and female actresses

Hovering over a bar shows a tooltip to show how many persons have been born within the year span and are an actor or an actress respectively

### Professions
A pie chart, showing how many people have which profession. The values can be seen by hovering onto the diagram.
