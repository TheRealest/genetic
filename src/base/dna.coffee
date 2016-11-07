# Dna class which maintains its genes and can perform crossover, mutation, and
# fitness calculation.

module.exports = class Dna
  # Genes which this Dna operate on
  genes: null
  # Fitness of current genes
  fitness: 0

  # If no genes are passed in the Dna will automatically generate them using
  # the generateGenes function; genes can be any data structure
  constructor: (@genes) ->
    @generateGenes() unless @genes

  # Randomly generate genes and store them in @genes
  generateGenes: ->
    @genes = null

  # Calculate current fitness and store it in @fitness
  calculateFitness: ->
    @fitness = 0

  # Perform crossover with another Dna instance, producing a new Dna instance
  # with some genes from both parent Dnas
  crossover: (otherDna) ->
    return new Dna @genes

  # Perform mutation, replacing some genes with new, random ones
  mutate: ->
    return @
