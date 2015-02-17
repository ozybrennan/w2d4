require_relative 'board.rb'
require_relative 'humanplayer.rb'

class Game

	attr_reader :red, :black, :board

	def initialize(red, black)
		@board = Board.new(empty = true)
		board[[1, 2]] = Piece.new(board, [1,2], :black)
		board[[3, 4]] = Piece.new(board, [3, 4], :black)
		board[[4, 5]] = Piece.new(board, [4, 5], :red)
		board[[3, 6]] = Piece.new(board, [3, 6], :black)
		@red = red
		@black = black
	end

	def play
		player = red
    	turns = 0
    	until over?
        	puts "#{player.color}'s turn."
        	board.render_board
        	begin
        	begin
        	begin
        		jumps = board.mandatory_jump(player.color)
        		if jumps.empty?
        			start, move_sequence = player.play_turn(board)
        		else
        			start, move_sequence = player.must_jump(jumps)
        		end
         	rescue InvalidMoveError => e
          		p e.message
          		retry
          	end
          	raise InvalidMoveError.new "there's no piece there" if board[start].nil?
          	rescue InvalidMoveError => e	
          		p e.message
          		retry
          	end
	        	board[start].perform_moves(move_sequence, player.color)
         	rescue InvalidMoveError => e
          		p e.message
          		retry
          	end
      		player = flip_turns(player)
      	 end
      	puts "Game over, #{flip_turns(player).color} wins!"
    	board.render_board
	end

	def flip_turns(player)
    	player == red ? black : red
 	end

 	def over?
 		pieces = board.grid.flatten.compact 
 		return true if pieces.all? { |piece| piece.color == :red }
 		return true if pieces.all? { |piece| piece.color == :black }
 		false
 	end


end
