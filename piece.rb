class InvalidMoveError < StandardError
end

class Piece
	attr_reader :color, :board
	attr_accessor :symbol, :king, :pos

	def initialize(board, pos, color, king=false)
		@board = board
		@pos = pos
		@color = color
		@king = king
		@symbol = "o" if color == :red
		@symbol = "x" if color == :black 
	end

	def perform_slide(move)
		moves = find_move_set(move_diffs)
		moves
		if moves.include?(move)
			board[move] = self
			board[move].maybe_promote
			board[pos] = nil
			@pos = move
			board[move].maybe_promote
			true
		else
			false
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
		if king == true
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
		return false unless jumps.include?(move)
		y, x = pos
		y2, x2 = move
		opponent_pos = [(((y2 - y) / 2) + y), (((x2 - x) / 2) + x)]
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

	def mandatory_jump
		new_board = board.dup
		new_board.grid.flatten.compact.each do |piece|
			jump_diffs = move_diffs.map { |y, x| [y * 2, x * 2] }
			jumps = find_move_set(jump_diffs)
			jumps.each do |jump|
				done = perform_jump(jump)
				if done
					p "You have to jumto #{jump}."
					perform_moves
				end
			end
		end
	end

	def perform_moves(move_sequence = nil, player_color)
		raise InvalidMoveError.new "wrong color" unless color == player_color
		return if move_sequence.nil?
		moves = move_sequence.dup
		if valid_move_seq?(moves)
			perform_moves!(move_sequence)
		else
			raise InvalidMoveError.new "you can't go there"
		end
	end

	def maybe_promote
		if (pos[0] == 0 && color == :red) || (pos[0] == 7 && color == :black)
			@king = true
			@symbol = "O" if color == :red && king == true
			@symbol = "X" if color == :black && king == true
		end
	end

end
