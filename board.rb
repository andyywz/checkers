class Board
  attr_accessor :board

  def initialize
    @pieces = []
    make_new_board(true)
  end

  def make_new_board(fill_board)
    @board = Array.new(8) { Array.new(8) }

    if fill_board
      red_rows = [0,1,2]
      black_rows = [5,6,7]

      @board.each_index do |row|
        fill_row(:rd, row) if red_rows.include?(row)
        fill_row(:bk, row) if black_rows.include?(row)
      end
    end
  end

  def fill_row(color, row)
    puts "got here"
    @board[row].each_index do |col|
      next unless row % 2 == col % 2
      @board[row][col] = color
    end
  end
end

# b = Board.new
# b.board.each {|line| p line}