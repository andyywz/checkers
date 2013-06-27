# encoding: UTF-8

require './piece.rb'
require 'colorize'

class Board
  attr_accessor :board, :pieces

  def initialize(fill_board = true)
    @pieces = []
    make_new_board(fill_board)
    fill_pieces
  end

  def make_new_board(fill_board)
    @board = Array.new(8) { Array.new(8) }

    if fill_board
      white_rows = [0,1,2]
      black_rows = [5,6,7]

      @board.each_index do |row|
        fill_row(:white, row) if white_rows.include?(row)
        fill_row(:black, row) if black_rows.include?(row)
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
    @pieces = @board.flatten.compact
  end

  def valid_spot?(row,col)
    return true if row % 2 == col % 2
    false
  end

  def empty_spot?(row,col)
    return true if self.board[row][col].nil?
    false
  end

  def non_empty_spot?(row,col)
    !empty_spot?(row,col)
  end

  def draw_board
    self.pieces = self.pieces.flatten.compact

    puts "   0  1  2  3  4  5  6  7"

    8.times do |row|
      print "#{row} "
      8.times do |col|

        self.pieces.each do |piece|
          if piece.position == [row,col]
            if piece.king == true
              print " W ".colorize(:background => :white) if piece.color == :white
              print " B ".colorize(:background => :white) if piece.color == :black
            else
              print " w ".colorize( :background => :white ) if piece.color == :white
              print " b ".colorize( :background => :white ) if piece.color == :black
            end
          end
        end

        if self.board[row][col].nil?
          print "   ".colorize( :background => :white ) if valid_spot?(row,col)
          print "   ".colorize( :background => :red ) unless valid_spot?(row,col)
        end

      end
      puts
    end
  end

  def duplicate
    test_board = Board.new(false)

    8.times do |row|
      8.times do |col|
        if self.non_empty_spot?(row,col)
          test_board.board[row][col] = self.board[row][col].dup
        else
          test_board.board[row][col] = nil
        end
      end
    end

    test_board.fill_pieces # @pieces = [oiwnefoinwef]
    test_board
  end
end


b = Board.new
b.board[2][2].perform_slide([3,3], b)
b.draw_board

new_b = b.duplicate

# new_b.pieces
# new_b.draw_board
new_b.board[5][5].perform_slide([4,4], b)
new_b.draw_board
b.draw_board

# b.board[5][5].perform_slide([4,4], b)
# p b.board[3][3].position
# b.board[3][3].perform_jump([5,5], b)
#
# b.board[5][3].perform_slide([4,4], b)
# b.board[6][4].perform_slide([5,3], b)
# b.board[7][3].perform_slide([6,4], b)
# b.board[5][5].perform_jump([7,3], b)
# b.pieces.each {|piece| piece.promote }
#
# b.board[5][1].perform_slide([4,0], b)
# b.board[7][3].perform_jump([5,1], b)
# b.draw_board

# b.pieces.each do |piece|
#   p piece.position
# end

