class Mastermind
  def initialize
    @codemaker_array = []
    @codebreaker_array = []
    @colours = ["red", "yellow", "green", "blue", "black", "white"]
    @computer_points = 0
    @player_points = 0;
    @role = ""
  end

  def setup_game
    @codemaker_array = []
    @codebreaker_array = []
    @role = ""
    puts "_____________________________________________________________________"
    puts "\nCodebreaker has 12 turns to guess the code.\nCodemaker gets one point for every guess that the codebreaker makes."
    puts "_____________________________________________________________________"
    puts "\nAvailable colours: [#{format_array(@colours)}]"
    puts "_____________________________________________________________________"
    puts "\nKey:\n'-' means that colour is present in the codemaker's code\n'*' means that colour is in right position\n" +
    "' ' means that colour is not present in codemaker's code"
    puts "_____________________________________________________________________"
    puts
    sleep 1
    print "Choose your role, type 'maker' or 'breaker': "
    @role = gets.chomp.downcase
    if @role.eql?("breaker")
      computer_fill_array(@codemaker_array)
      sleep 1
      puts "Computer has generated code!"
      puts
    elsif @role.eql?("maker")
      player_fill_array(@codemaker_array)
    else
      puts "Invalid input!"
      setup_game()
    end
    
    start()
  end

  def format_array(array)
    array.to_s.gsub(", "," | ").sub("]","").sub("[","").gsub("\"","")
  end

  def pick_colours
    idx = rand(0..5)
  end

  def start
    number_of_turns = 0
    previous_array = []
    previous_output = []

    until number_of_turns == 12
      output = []

      if @role.eql?("breaker")
        @computer_points += 1
        play_as_breaker()
      else
        @player_points += 1
        sleep 1
        play_as_maker(previous_output, previous_array)
      end

      check_arrays(output)

      puts "Guess: [ #{format_array(@codebreaker_array)} ]"
      puts "Hint : [ #{format_array(output.shuffle())} ]"
      puts

      if @codebreaker_array == @codemaker_array
        break
      end

      previous_array = @codebreaker_array
      previous_output = output
      @codebreaker_array = []

      number_of_turns += 1
    end 

    check_win(number_of_turns)    
  end

  def check_win(number_of_turns)
    if number_of_turns < 12
      if @role.eql?("maker")
        puts "Computer has broken your code!"
      else
        puts "You have broken the computer's code!"
      end
    else
      if @role.eql?("maker")
      puts "Computer has failed to break your code!"
      puts "Code was: #{@codemaker_array}"
      @player_points += 1
      else
      puts "You have failed to break the computer's code!"
      puts "Code was: #{@codemaker_array}"
      @computer_points += 1
      end
    end
    restart()
  end

  def restart
    print "Play again? 'Y' for yes, any other key for no: "
    choice = gets.chomp.upcase
    case choice
    when "Y" then setup_game()
    else 
      print_results()
    end
  end

  def print_results
    puts "_________________________"
    puts "Final results:"
    puts "Computer points: #{@computer_points}\nPlayer points: #{@player_points}"
    puts "_________________________"
  end

  def check_arrays(output)
    @codemaker_array.each_with_index do |element, idx|
      if @codemaker_array.include?(@codebreaker_array[idx])
        if element.eql?(@codebreaker_array[idx])
          output << "*"
        else
          output << "-"
        end
      else
        output << " "
      end
    end
  end

  def play_as_breaker
    player_fill_array(@codebreaker_array)
  end

  def player_fill_array(array)
    i = 0
    puts "Add colours add specified index:"
    puts
    until array.length == 4
      print "Index: #{i}"
      print ", Colour: "
      colour = gets.chomp.downcase
      if @colours.include?(colour)
        array << colour
        i += 1
      else
        puts "Invalid input!"
        next
      end
    end
    puts
  end

  def computer_fill_array(array)
    until array.length == 4
      idx = pick_colours()
      unless array.include?(@colours[idx])
        array << @colours[idx]
      else
        next
      end
    end
  end

  def play_as_maker(output, previous)
    if previous.length == 0
      computer_fill_array(@codebreaker_array)
    else
      output.each_with_index do |element, index|
        if element.eql?("*")
          @codebreaker_array[index] = previous[index]
        end
        computer_fill_array(@codebreaker_array)
      end
    end
  end
end

game = Mastermind.new
game.setup_game