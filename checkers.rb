require './player.rb'
require './board.rb'
require './piece.rb'
require 'colorize'

class InvalidMoveError < StandardError
end

class Checkers
  def initialize
    @player1 = HumanPlayer.new(:white)
    @player2 = HumanPlayer.new(:black)
    @board = Board.new
    play
  end

  def play
    player = @player1

    while true
      @board.draw_board
      begin
        player_color = player.color
        enemy_color = player.color == :white ? :black : :white
        move_sequence = player.turn
        start_pos = move_sequence[0]
        if @board.non_empty_spot?(start_pos[0],start_pos[1])
          piece = @board.board[start_pos[0]][start_pos[1]]

          if piece.color != player_color
            raise InvalidMoveError.new "Not your color!"
          end

          valid = piece.valid_move_seq?(move_sequence, @board)
          piece.perform_moves(move_sequence, @board) if valid
          piece.promote

        else
          raise InvalidMoveError.new "No piece in start position"
        end
      rescue InvalidMoveError => e
        puts e
        retry
      end
      @board.draw_board
      player = player == @player1 ? @player2 : @player1
    end
  end
end

# Checkers.new

if __FILE__ == $0
  Checkers.new
end