Dna = require './dna'
CONSTANTS = require '../constants'

# Population class which manages each of its member Dna instances. It can
# perform selection to create a new generation from the old one, and has
# functions for fitness calculation and crossover which simply call the methods
# of the same name on each member Dna.

module.exports = class Population
  # Array of member Dna instances with length CONSTANTS.POPULATION_SIZE
  members: []
  # Generation number, incremented every time @evolve is called
  generationNumber: 0
  # Member Dna with the maximum fitness
  maxFitnessMember: null
  # Flag which indicates whether a member of the population has reached the
  # goal fitness yet
  finished: false

  # If no array of member Dna instances is passed in the Population will
  # automatically generate it using the generateMembers function
  constructor: (@members = []) ->
    throw new Error('members must be an array') unless Array.isArray @members

    @generateMembers() unless @members.length
    @calculateFitness()

  # Randomly generate member Dna instances and store them in @members
  generateMembers: ->
    newMembers = []
    for index in [0...CONSTANTS.POPULATION_SIZE]
      newMembers.push new Dna

    @members = newMembers

  # Calculate fitness for each member and keep track of the member with
  # greatest fitness
  calculateFitness: ->
    member.calculateFitness() for member in @members
    @maxFitnessMember = @getMaxFitnessMember()

  getMaxFitnessMember: ->
    return @members.reduce (maxFitnessMember, member) ->
      return if maxFitnessMember.fitness >= member.fitness
        maxFitnessMember
      else
        member

  # Generate next generation's population from current @members by performing
  # selection, crossover, mutation, etc. This will also check the
  # @maxFitnessMember to see if its fitness is above the goal fitness.
  evolve: ->
    newMembers = []
    for index in [0...CONSTANTS.POPULATION_SIZE]
      memberA = @selectMember()
      memberB = @selectMember()

      newMember = memberA.crossover memberB
      newMember.mutate()

      newMembers.push newMember

    @members = newMembers
    @generationNumber++

    @calculateFitness()
    @finished = true if @maxFitnessMember.fitness >= CONSTANTS.GOAL_FITNESS

  # Select a member from the current population using a weighted random
  # selection process based on fitness; requires that the fitness of each Dna
  # is up to date i.e. calculateFitness has been called since any changes to
  # its genes
  selectMember: ->
    return
