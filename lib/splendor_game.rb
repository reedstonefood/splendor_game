require "splendor_game/version"
require "splendor_game/card"
require "splendor_game/noble"
require "splendor_game/tableau"
require "splendor_game/player"
require "splendor_game/turn"
require "splendor_game/load_cards"
require "splendor_game/game"


module SplendorGame
  # This is to validate when loading cards
  VALID_COLOUR_LIST = ["RED", "BLUE", "BLACK", "GREEN", "WHITE"]
  # This is used to validate certain calls
  VALID_COLOUR_SYMBOLS = VALID_COLOUR_LIST.map { |x| x.downcase.to_sym }
  # Note gold is a special colour so shouldn't be in VALID_COLOUR_LIST
  VALID_COLOUR_SYMBOLS << :gold
  
  MAX_PLAYER_COUNT = 4
  
end
