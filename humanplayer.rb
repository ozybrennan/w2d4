
class HumanPlayer
  LETTERS_TO_NUM = ("a".."h").to_a

  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end

  def play_turn(board)
    puts "Please enter your move."
    move = gets.chomp
    raise InvalidMoveError.new "That isn't a move" unless valid_input?(move)
    arr = move.split(",").map! { |s| s.strip.split("") }
    arr.map! { |y, x| [x.to_i - 1, LETTERS_TO_NUM.index(y)] }
    start = arr.shift
    [start, arr]
  end

  def valid_input?(str)
    moves = str.strip.split(",")
    moves.each do |move|
      chrs = move.strip.split("")
      if chrs.length != 2
      return false
      elsif !LETTERS_TO_NUM.include?(chrs[0])
      return false
      elsif chrs[1].to_i.zero?
      return false
      elsif chrs[1].to_i > 8 
      return false
      else
      true
      end
    end
  end
end

class InvalidMoveError < StandardError
end