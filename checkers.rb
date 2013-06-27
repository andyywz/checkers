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
      begin
        start_pos, end_pos = player.turn
        player_color = player.color
        enemy_color = player.color == :white ? :black : :white

        if @board.valid_spot?(start_pos[0],start_pos[1])
          piece = @board[start_pos[0]][start_pos[1]]

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

def draw
puts "  0 1 2 3 4 5 6 7"
8.times do |row|
  print "#{row}  "
  8.times do |col|
    print "  ".colorize( :background => :black ) if row % 2 == col % 2
    print "  ".colorize( :background => :red ) unless row % 2 == col % 2
  end
  puts
end
end