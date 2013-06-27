require './checkers.rb'

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
      raise "InvalidMoveError"
    end
  end

  def perform_jump(end_pos, board)
    x1, y1 = self.position[0], self.position[1]
    x2, y2 = end_pos[0], end_pos[1]
    x, y = x2 - x1, y2 - y1

    p [x,y]
    if jump_moves.include?([x,y]) && board.board[x2][y2].nil?
      middle_piece = board.board[(x1 + x2) / 2][(y1 + y2) / 2]
    else
      puts "I failed 1"
      return
    end

    if !middle_piece.nil? && middle_piece.color != self.color
      puts "im here"
      self.position = end_pos
      board.pieces.delete(middle_piece)
      board.board[x2][y2] = self
      board.board[x1][y1] = nil
      board.board[(x1 + x2) / 2][(y1 + y2) / 2] = nil
    else
      puts "I failed 2"
      return
    end
  end

  def perform_moves(move_sequence, board_obj)
      perform_moves!(move_sequence, board_obj)
  end

  def valid_move_seq?(move_sequence, board_obj)
    test_board = board_obj.dup
    begin
      perform_moves!(move_sequence, test_board)
    rescue
      raise InvalidMoveError.new "Invalid move sequence"
    end
  end


  def perform_moves!(move_sequence,board_obj)
    #make moves on a board
    if move_sequence.length != 2
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
    self.class.new(color, position, king)
  end

end

# piece.promote if piece.in_last_row?

# valid_slides = []
# slide_moves.each do |move|
#   x, y = (move[0] + self.position[0]), (move[1] + self.position[1])
#   valid_slides << [x,y] if x.between?(0,7) and y.between?(0,7)
# end
# valid_slides
