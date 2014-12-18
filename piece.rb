class Piece

	attr_reader :symbol, :king, :color, :pos, :board

	def initialize(board, pos, color, king = false)
		@board = board
		@pos = pos
		@color = color
		@king = false
		@symbol = "P"
	end

	def perform_slide(move)
		moves = find_move_set(move_diffs)
		p moves
		if moves.include?(move)
			board[move] = self
			board[pos] = nil
			@pos = move
			p true
		else
			p false
		end
	end

	def find_move_set(possible_moves)
		y, x = pos
		moves = []
		possible_moves.each do |change|
			dy, dx = change
			move = [y + dy, x + dx]
			moves << move if on_board?(move) || board[move].nil?
		end
		moves
	end

	def on_board?(move)
		y, x = move
		y > -1 || x > -1 || x < 7 || y < 7
	end

	def move_diffs
		if king
			[[1,1], [-1,-1],[-1, 1], [1, -1]]
		elsif color == :black
			[[1,1], [1, -1]]
		else
			[[-1, 1], [-1, -1]]
		end
	end

	def perform_jump(move)
		jump_diffs = move_diffs.map { |y, x| [y * 2, x * 2] }
		jumps = find_move_set(jump_diffs)
		p "jumps don't include move" unless jumps.include?(move) 
		return false unless jumps.include?(move)
		y, x = pos
		y2, x2 = move
		opponent_pos = [(((y2 - y) / 2) + y), (((x2 - x) / 2) + x)]
		p opponent_pos
		return "tried to jump a piece you can't" if board[opponent_pos].nil? || board[opponent_pos].color == color
		return false if board[opponent_pos].nil? || board[opponent_pos].color == color
		board[move] = self
		board[pos] = nil
		board[opponent_pos] = nil
		@pos = move
		true
	end

	def perform_moves!(move_sequence)
		if move_sequence.length == 1
			move = perform_slide(move_sequence.first)
			move = perform_jump(move_sequence.first) unless move
			raise InvalidMoveError unless move
		else
			until move_sequence.count == 0
				move = perform_jump(move_sequence.shift)
				raise InvalidMoveError unless move
			end
		end
	end

	def dup
    	new_board = Board.new(empty = true)
    	board.grid.flatten.compact.each do |el|
      		new_board[el.pos] = Piece.new(new_board, el.pos, el.color, el.king)
    	end
   		new_board
  	end


	def valid_move_seq?(move_sequence)
		begin
			new_board = board.dup
			new_board[pos].perform_moves!(move_sequence)
		rescue InvalidMoveError
			false
		else
			true
		end
	end

end

class InvalidMoveError < StandardError
end