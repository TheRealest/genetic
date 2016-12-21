StringPopulation = require './string/population'

#GOAL_STRING = 'To be or not to be'
GOAL_STRING = 'To be or not to be or not to be'

stringPopulation = new StringPopulation GOAL_STRING
until (stringPopulation.finished)
  maxFitnessMember = stringPopulation.maxFitnessMember
  console.log '%s -- f: %s, g: %s', maxFitnessMember.toColoredString(), maxFitnessMember.fitness, stringPopulation.generationNumber
  stringPopulation.evolve()

if stringPopulation.endedEarly
  console.log '\nEnded early unsuccessfully after %s generations :(',
    stringPopulation.generationNumber
else
  console.log '\nDone!'
  console.log 'Found %s (%s) in %s generations with a population of %s',
    stringPopulation.maxFitnessMember.toColoredString(),
    stringPopulation.maxFitnessMember.fitness,
    stringPopulation.generationNumber,
    stringPopulation.members.length
