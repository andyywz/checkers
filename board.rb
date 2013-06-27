require_relative 'piece.rb'

class Board
  attr_accessor :board, :pieces

  def initialize
    @pieces = []
    make_new_board(true)
    fill_pieces
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
    @board[row].each_index do |col|
      next unless valid_spot?(row,col)
      @board[row][col] = Piece.new(color, [row,col])
    end
  end

  def fill_pieces
    @board.each_index do |row|
      @board.each_index do |col|
        next unless valid_spot?(row,col)
        @pieces << @board[row][col]
      end
    end
    @pieces = @pieces.flatten.compact
  end

  def valid_spot?(row,col)
    return true if row % 2 == col % 2
    false
  end
end

# b = Board.new
# b.board.each {|line| p line}
# p b.pieces