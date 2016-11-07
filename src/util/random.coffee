# A pseudorandom number generator. When a new instance is created, a seed can
# be passed in; this seed allows the generator to produce a predictable yet
# mostly random series of numbers. A variety of helper methods allow for
# different types of random numbers to be generated. This class/instance model
# allows for multiple deterministic generators to work in parallel, without
# disturbing each other.

module.exports = class Random
  # The seed passed in when this generator was created
  seed: null

  constructor: (@seed) ->

  # Delegation wrapper for Math.random()
  nativeRandom: (args...) -> Math.random(args...)
