#REV- this is some slick code

require './checkers.rb'
require './board.rb'

class Piece
  attr_accessor :color, :position, :king

  def initialize(color, position, king = false)
    @color = color
    @position = position
    @king = king
  end

  def promote
    self.king = true if in_last_row?
  end

  def in_last_row?
    last_row = (@color == :black) ? 0 : 7
    return true if self.position[0] == last_row
    false
  end

  def slide_moves
    direction = (@color == :black) ? -1 : 1
    all_slide_moves = [[direction,-1],[direction,1]]
    all_slide_moves += [[-1 * direction,-1],[-1 * direction,1]] if @king

    all_slide_moves
  end

  def jump_moves
    all_jump_moves = []
    slide_moves.each do |move|
      x, y = move
      all_jump_moves << [x * 2, y * 2]
    end
    p all_jump_moves
    all_jump_moves
  end

  def perform_slide(end_pos, board)
    x1, y1 = self.position[0], self.position[1]
    x2, y2 = end_pos[0], end_pos[1]
    x, y = x2 - x1, y2 - y1

    if slide_moves.include?([x,y]) && board.board[x2][y2].nil?
      self.position = end_pos
      board.board[x2][y2] = self
      board.board[x1][y1] = nil
    else
      raise InvalidMoveError.new "I can't slide like that!!"
    end
  end

  def perform_jump(end_pos, board)
    x1, y1 = self.position[0], self.position[1]
    x2, y2 = end_pos[0], end_pos[1]
    x, y = x2 - x1, y2 - y1

    if jump_moves.include?([x,y]) && board.board[x2][y2].nil?
      middle_piece = board.board[(x1 + x2) / 2][(y1 + y2) / 2]
    else
      raise InvalidMoveError.new "I can't jump like that!!"
    end

    if !middle_piece.nil? && middle_piece.color != self.color
      self.position = end_pos
      board.pieces.delete(middle_piece)
      board.board[x2][y2] = self
      board.board[x1][y1] = nil
      board.board[(x1 + x2) / 2][(y1 + y2) / 2] = nil
    else
      raise InvalidMoveError.new "I need to kill something!!"
    end
  end

  def perform_moves(move_sequence, board_obj)
      perform_moves!(move_sequence, board_obj)
  end

  def valid_move_seq?(move_sequence, board_obj)
    test_board = board_obj.duplicate
    test_piece = test_board.board[position[0]][position[1]]
    begin
      test_piece.perform_moves!(move_sequence, test_board)
      return true
    rescue
      return false
    end
  end


  def perform_moves!(move_sequence,board_obj)
    #make moves on a board
    if move_sequence.length == 2
      start_pos, end_pos = move_sequence
      dy = (start_pos[1] - end_pos[1]).abs
      if dy == 1
        perform_slide(end_pos, board_obj)
      else
        perform_jump(end_pos, board_obj)
      end
    else
      start_pos = move_sequence[0]
      move_sequence[1..-1].each do |end_pos|
        perform_jump(end_pos, board_obj)
        start_pos = end_pos
      end
    end

  end

  def dup
    x,y = position
    self.class.new(color, [x,y] , king)
  end

end
