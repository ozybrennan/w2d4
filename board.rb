require_relative 'piece.rb'

class Board

	attr_accessor :grid

	def initialize(empty = false)
		@grid = Array.new(8) { Array.new(8)}
    	build_board unless empty
	end

	def build_board
		light_starts_row(0, :black)
		dark_starts_row(1, :black)
		light_starts_row(2, :black)
		dark_starts_row(5, :red)
		light_starts_row(6, :red)
		dark_starts_row(7, :red)
	end

	def dark_starts_row(y, color)
		grid[y].each_index do |x|
			self[[y, x]] = Piece.new(self, [y, x], color) if x % 2 == 0
		end
    end

    def light_starts_row(y, color)
    	grid[y].each_index do |x|
			self[[y, x]] = Piece.new(self, [y, x], color) unless x % 2 == 0
		end
    end

	def render_board
    puts "   |  " + ("a".."h").to_a.join("  ")
    puts "---+------------------------"

    grid.each_with_index do |row, i|
      row_string = "#{i + 1}  |  "
      row.each do |tile|
        if tile.nil?
          row_string << "_  "
        else
          row_string << tile.symbol + "  "
        end
      end

      puts row_string
    end
    puts

    nil
  end

   def [](position)
    y, x = position
    grid[y][x]
  end

  def []=(cur_pos, new_obj)
    y, x = cur_pos
    grid[y][x] = new_obj
  end

  def dup
    new_board = Board.new(empty = true)
    grid.flatten.compact.each do |el|
      	new_board[el.pos] = Piece.new(new_board, el.pos, el.color, el.king)
    end
   	new_board
  	end

end

b = Board.new
b.render_board
b[[2, 1]].perform_slide([3, 0])
b[[3, 0]].perform_slide([4, 1])
b[[1, 2]].perform_slide([2, 1])
b.render_board
p b[[5, 2]].valid_move_seq?([[3, 0], [1, 2]])
b.render_board
p b[[1, 2]].pos