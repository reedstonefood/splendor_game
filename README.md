# Splendor_game

[![Code Climate](https://codeclimate.com/github/reedstonefood/splendor_game/badges/gpa.svg)](https://codeclimate.com/github/reedstonefood/splendor_game)

A Ruby implementation of the board game Splendor. 

Find out more about the game at [BoardGameGeek](https://boardgamegeek.com/boardgame/148228/splendor).

## Installation

    gem install splendor_game

## Usage

There is a simple CLI you can use, which requires [Highline](https://github.com/JEG2/highline). Simply run the following in irb or put in a .rb file and run it.

```ruby
require 'splendor_game'
SplendorGame::CLI.new
```

Or, hook this up to any front end you might desire to use. If you do this, I'd be interested in knowing the details.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/reedstonefood/splendor_game.

## With thanks...

Whoever typed up a list of all the cards in the board game into [this spreadsheet](https://drive.google.com/file/d/0B4yyYVH10iE5VlBFME9QelBVUnc/edit). 

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

