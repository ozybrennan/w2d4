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

  def mandatory_jump(color)
    new_board = self.dup
    final_jumps = []
    board = new_board.grid.flatten.compact.select { |piece| piece.color == color}
    board.each do |piece|
      jump_diffs = piece.move_diffs.map { |y, x| [y * 2, x * 2] }
      jumps = piece.find_move_set(jump_diffs)
      jumps.each do |jump|
        even_newer_board = self.dup
        done = even_newer_board[piece.pos].perform_jump(jump)
        final_jumps << jump if done
      end
    end
    final_jumps
  end

end