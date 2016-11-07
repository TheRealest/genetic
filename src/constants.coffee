# Total number of member Dna instances per Population
POPULATION_SIZE = 200
# When a member Dna of a Population reaches this fitness, it sets
# Population.finished to true to stop the algorithm
GOAL_FITNESS = 1

# Rate at which crossover happens per gene
CROSSOVER_RATE = 0.5
# Rate at which mutation happens, per gene
MUTATION_RATE = 0.01

module.exports = {
  POPULATION_SIZE
  GOAL_FITNESS
  CROSSOVER_RATE
  MUTATION_RATE
}
