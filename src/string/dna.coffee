require 'colors'
Dna = require '../base/dna'
Random = require '../util/random'
CONSTANTS = require '../constants'

# Allowed character list, constructed via String.fromCharCode to include a-z,
# A-Z, and space
ALLOWED_CHARACTERS = [String.fromCharCode 32] # 32: <space>
  .concat (String.fromCharCode code for code in [65..90]) # 65-90: A-Z
  .concat (String.fromCharCode code for code in [97..122]) # 97-122: a-z

# Dna subclass for genes which are strings (actually an array of characters)

module.exports = class StringDna extends Dna
  # Genes which this Dna operate on
  genes: []
  # Fitness of current genes
  fitness: 0
  # Random number generator for this instance
  random: new Random

  # If no genes are passed in the Dna will automatically generate them using
  # the generateGenes function; genes can be any data structure
  constructor: (@goalString = '', @genes, @seed = @random.realUnit()) ->
    super @genes

  # Randomly generate genes and store them in @genes
  generateGenes: ->
    newGenes = []
    for index in [0...@goalString.length]
      newGenes.push @generateRandomCharacter()

    @genes = newGenes

  # Calculate current fitness and store it in @fitness
  calculateFitness: ->
    newFitness = 0
    goalGenes = @goalString.split ''
    console.log goalGenes
    for character, index in @genes
      console.log character, goalGenes[index]
      newFitness++ if character == goalGenes[index]
    return @fitness = newFitness

  # Perform crossover with another Dna instance, producing a new Dna instance
  # with some genes from both parent Dnas
  crossover: (otherDna) ->
    return new Dna @genes

  # Perform mutation, replacing some genes with new, random ones
  mutate: ->
    return @

  # Return a random character in the range a-zA-Z plus space
  generateRandomCharacter: ->
    return @random.fromArray(ALLOWED_CHARACTERS)

  # Concats the genes together for display -- setting this to both toString and
  # inspect causes the genes to be used in string interpolations/concats and by
  # console.log
  toString: ->
    return @genes.join ''
  inspect: @::toString

  # Concats the genes together but also colors them based on which characters
  # match the goal string
  toColoredString: ->
    goalGenes = @goalString.split ''
    coloredGenes = for character, index in @genes
      if character == goalGenes[index]
        character.green.underline
      else
        character.red.bold
    return coloredGenes.join ''
