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

  def perform_slide
  end

  def perform_jump
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