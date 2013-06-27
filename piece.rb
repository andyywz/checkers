class Piece
  attr_reader :color, :king
  attr_accessor :position

  def initialize(color, position)
    @color = color
    @position = position
    @king = false
  end

  def slide_moves
    direction = (@color == :red) ? -1 : 1
    all_slide_moves = [[direction,-1],[direction,1]]
    all_slide_moves += [[-direction,-1],[-direction,1]] if @king

    all_slide_moves
  end

  def jump_moves
    all_jump_moves = []
    slide_moves.each do |move|
      x, y = move
      all_jump_moves << [x * 2, y * 2]
    end

    all_jump_moves
  end

  def perform_slide(end_pos, board)
    x1, y1 = self.position[0], self.position[1]
    x2, y2 = end_pos[0], end_pos[1]
    x, y = x2 - x1, y2 - y1

    if slide_moves.include?([x,y]) && board[x2][y2].nil?
      self.position = end_pos
    else
      raise "InvalidMoveError"
    end
  end

  def perform_jump(end_pos, board)
    x1, y1 = self.position[0], self.position[1]
    x2, y2 = end_pos[0], end_pos[1]
    x, y = x2 - x1, y2 - y1

    if jump_moves.include?([x,y]) && board[x2][y2].nil?
      middle_piece = board[(x1 + x2) / 2][(y1 + y2) / 2]
      unless middle_piece.nil? || middle_piece.color == self.color
        self.position = end_pos
        middle_piece = nil
      end
    else
      raise "InvalidMoveError"
    end
  end

  def perform_moves(move_sequence, board)
    perform_moves!(move_sequence, board) if valid_move_seq?(board)
  end

  def valid_move_seq?(board)
    test_board = board.dup
    perform_moves!(move_sequence)
  end

  def perform_moves!(move_sequence)

  end

  def promote
    self.king = true
  end

  def in_last_row?
    last_row = (@color == :red) ? 0 : 7
    return true if self.position[0] == last_row
    false
  end

end

# piece.promote if piece.in_last_row?

# valid_slides = []
# slide_moves.each do |move|
#   x, y = (move[0] + self.position[0]), (move[1] + self.position[1])
#   valid_slides << [x,y] if x.between?(0,7) and y.between?(0,7)
# end
# valid_slides
