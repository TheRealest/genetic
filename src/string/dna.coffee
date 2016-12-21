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
  # Random number generator for this class, shared by all instances
  random: new Random

  # If no genes are passed in the Dna will automatically generate them using
  # the generateGenes function; genes can be any data structure
  constructor: (@goalString = '', @genes, @seed = @random.realUnit()) ->
    super @genes

  # Randomly generate characters with the same length as the goalString and
  # store them in @genes
  generateGenes: ->
    newGenes = []
    for index in [0...@goalString.length]
      newGenes.push @generateRandomCharacter()

    @genes = newGenes

  # Fitness is calculated by comparing the genes to the goalString
  # character-wise -- each match adds one to the fitness, to a maximum of
  # goalString.length
  calculateFitness: ->
    newFitness = 0
    goalGenes = @goalString.split ''
    for character, index in @genes
      newFitness++ if character == goalGenes[index]
    return @fitness = newFitness

  # Delegates to one of three crossover strategies: _crossoverCharacterWise or
  # _crossoverSplitFixed, _crossoverSplitRandom
  crossover: (otherDna) ->
    #return @_crossoverCharacterWise otherDna
    return @_crossoverSplitFixed otherDna
    #return @_crossoverSplitRandom otherDna

  # Each character is considered independently and has a 50/50 chance to be
  # taken from either parent
  _crossoverCharacterWise: (otherDna) ->
    newGenes = []
    for character, index in @genes
      otherCharacter = otherDna.genes[index]
      newGenes.push if @random.boolean() then character else otherCharacter
    return new StringDna @goalString, newGenes

  # The genes from one parent up to a fixed point are combined with the genes
  # from the other parent after that fixed point to create the new Dna --
  # defaults to the midpoint
  _crossoverSplitFixed: (otherDna, splitPoint) ->
    splitPoint ?= Math.floor(@genes.length / 2)
    newGenes = []
    for index in [0...@genes.length]
      newGenes.push if index < splitPoint
        @genes[index]
      else
        otherDna.genes[index]
    return new StringDna @goalString, newGenes

  # Same as _crossoverSplitFixed except the split point is randomly chosen
  _crossoverSplitRandom: (otherDna) ->
    return _crossoverSplitFixed otherDna, @random.integerFromRange(@genes.length + 1)

  # Each character is replaced with a new random character at a rate of
  # CONSTANTS.MUTATION_RATE
  mutate: ->
    newGenes = []
    for character, index in @genes
      newGenes.push if @random.boolean CONSTANTS.MUTATION_RATE
        @generateRandomCharacter()
      else
        character
    return new StringDna @goalString, newGenes

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
