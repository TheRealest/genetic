Dna = require './dna'
Random = require '../util/random'
CONSTANTS = require '../constants'

# Population class which manages each of its member Dna instances. It can
# perform selection to create a new generation from the old one, and has
# functions for fitness calculation and crossover which simply call the methods
# of the same name on each member Dna.

module.exports = class Population
  # Array of member Dna instances with length CONSTANTS.POPULATION_SIZE
  members: []
  # Random number generator for this class, shared by all instances
  random: new Random
  # Generation number, incremented every time @evolve is called
  generationNumber: 1
  # Member Dna with the maximum fitness
  maxFitnessMember: null
  # Flag which indicates whether a member of the population has reached the
  # goal fitness yet
  finished: false
  # Flag which indicates the population ended early unsuccessfully
  endedEarly: false

  # If no array of member Dna instances is passed in the Population will
  # automatically generate it using the generateMembers function
  constructor: (@members = []) ->
    throw new Error('members must be an array') unless Array.isArray @members

    @generateMembers() unless @members.length
    @calculateFitness()

  # Randomly generate member Dna instances and store them in @members -- should
  # be overwritten by Population subclass
  generateMembers: ->
    @members = []

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
    @finished = @isFinished()

  # Method used to select members from the population when performing the
  # evolution step -- requires that fitness has been calculated since any
  # changes to members or their genes. By default it simply chooses one member
  # at weighted random based on fitness, but can be overwritten by the
  # Population subclass to implement a specific selection strategy
  selectMember: ->
    weightedMembers = for member in @members
      {weight: member.fitness, value: member}
    return @random.fromWeightedArray weightedMembers

  # Method for determining if the evolution process is "done" -- requires that
  # fitness has been calculated since any changes to members or their genes.
  # May need to be overwritten depending on the specific implementation.
  isFinished: ->
    if @generationNumber < CONSTANTS.MAX_GENERATION
      return @maxFitnessMember.fitness >= CONSTANTS.GOAL_FITNESS
    else
      @endEarly()
      return true

  # Should be overwritten by the Population subclass to print information about
  # the state of the population in case MAX_GENERATION is reached without
  # finishing normally
  endEarly: ->
    @endedEarly = true
