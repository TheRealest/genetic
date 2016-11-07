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

  # Returns a random value in the interval [0,1)
  realUnit: ->
    # TODO: for now this delegates to the native random
    # function
    return @_nativeRandom()

  # Returns a random value in the interval [min, max) -- if only
  # one value is passed it's used as the maximum and the minimum
  # defaults to 0. Behavior is undefined if min > max.
  realFromRange: (min, max) ->
    unless max?
      max = min ? 1
      min = 0
    return @realUnit() * (max - min) + min

  # Returns a random integer in the interval [min, max) -- if only one value
  # is passed it's used as the maximum and the minimum defaults to 0.
  # Behavior is undefined if min + 1 > max.
  integerFromRange: (min, max) ->
    return Math.floor @realFromRange(min, max)

  # Returns a random element from an array with equal probability for each
  fromArray: (array) ->
    index = @integerFromRange array.length
    return array[index]

  # Delegation wrapper for Math.random()
  _nativeRandom: (args...) -> Math.random(args...)
