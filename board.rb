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
    new_board = Board.new(false)

    self.board.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        new_board.board[i][j] = piece.dup unless piece.nil?
      end
    end

    new_board
  end
end
