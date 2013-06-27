class Player
  attr_accessor :color

  def initialize(color)
    @color = color
  end
end

class HumanPlayer < Player
  def turn
    begin
      puts "#{self.color.to_s.capitalize}'s turn"
      puts "Choose a square to move from (e.g. 0,0):"
      start_pos = prompt_pos
    rescue ArgumentError.new => e
      puts "Please limit your input (e.g. 0,0 -> 7,7)."
      retry
    end

    begin
      puts "Choose a square to move to (e.g. 1,5):"
      end_pos = prompt_pos
    rescue ArgumentError.new => e
      puts "Please limit your input (e.g. 0,0 -> 7,7)."
      retry
    end

    [start_pos,end_pos]
  end

  def prompt_pos
    pos = gets.chomp.split(',')

    unless pos.length == 2 && pos[0].between?("0","7") && pos[1].between?("0","7")
      raise ArgumentError.new "Input invalid!"
    end

    [pos[0].to_i, pos[1].to_i]
  end
end

class ComputerPlayer < Player
end