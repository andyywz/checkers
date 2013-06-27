class Checkers
  def initialize
    @player1 = HumanPlayer.new(:red)
    @player2 = HumanPlayer.new(:black)
    @board = Board.new
    play
  end

  def play
    player = @player1

    while true
      begin
        start_pos, end_pos = player.turn
        player_color = player.color
        enemy_color = player.color == :red ? :black : :red





        if @board.valid_move?(start_pos, end_pos, player_color)
          @board.move(start_pos,end_pos) # unless @board.check?(player_color)
          # @board.check?(enemy_color)
        else
          raise ArgumentError.new "Invalid move!"
        end
      rescue ArgumentError => e
        puts e
        retry
      end
      player = player == @player1 ? @player2 : @player1
    end
  end
end