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
      puts "Enter move sequence (e.g. 22 31): "
      move_sequence = prompt_pos
    rescue ArgumentError.new => e
      puts "Please limit your input (e.g. 00 -> 77)."
      retry
    end

    move_sequence
  end

  def prompt_pos
    move_seq = gets.chomp.scan(/[0-7][0-7]/)

    if move_seq.length < 2
      raise ArgumentError.new "Input invalid!"
    end

    move_seq.map! do |pair|
      pair.split("").map! {|i| i.to_i}
    end
    move_seq
  end
end

class ComputerPlayer < Player
end