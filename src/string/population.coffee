Population = require '../base/population'
StringDna = require './dna'
CONSTANTS = require '../constants'

# Population class which manages each of its member Dna instances. It can
# perform selection to create a new generation from the old one, and has
# functions for fitness calculation and crossover which simply call the methods
# of the same name on each member Dna.

module.exports = class StringPopulation extends Population
  # The string this population is evolving towards
  goalString: ''

  # The goalString is used to evaluate fitness for each member, as well as to
  # know when to stop (when a member's genes match the goalString exactly i.e.
  # it has the maximum possible fitness)
  constructor: (@goalString = '', @members = []) ->
    super @members

  generateMembers: ->
    @members = (new StringDna @goalString for i in [0...CONSTANTS.POPULATION_SIZE])

  isFinished: ->
    if @generationNumber < CONSTANTS.MAX_GENERATION
      return @maxFitnessMember.fitness == @goalString.length
    else
      @endEarly()
      return true

  endEarly: ->
    @endedEarly = true
    console.log '\nEnded early after %s generations without reaching goal string...', @generationNumber
    console.log 'Final population:'

    sortedMembers = @members.sort (a, b) -> a.fitness - b.fitness
    console.log '%s -- %s', member.toColoredString(), member.fitness for member in sortedMembers
