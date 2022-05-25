class Game
    attr_accessor :computer_word, :turn_number, :wrong_guesses, :hint, :current_guess, :win
    def initialize()
        dictionary = File.open("google-10000-english-no-swears.txt", 'r')
        @computer_word = generate_word(dictionary)
        @turn_number = 1
        @wrong_guesses = []
        @hint = Array.new(@computer_word.length, "_")
        @win = false
    end

    def generate_word(dictionary)
        eligible_words =[]
        dictionary.each do |line|
            line.chomp!
            if line.length > 4 && line.length < 12
                eligible_words.push(line)
            end
        end
        return eligible_words[(rand(eligible_words.length-1)-1)].split("")
    end 

    def directions()
        puts "Welcome to Hangman!  The rules of the game are very simple."
        puts "The computer will generate a random word between 6 and 12 letters."
        puts "It's your job to guess what that word is."
        puts " "
        puts "Each turn, you can guess one letter to the word. If you're right, the computer will indicate that and show you where the letter is located in the word."
        puts " "
        puts "If you're wrong, the computer will add the letter to the list of incorrect guesses you've made."
        puts " "
        puts "If you guess incorrectly 6 times, you lose."
        puts " "
        puts "You can enter 'exit' to leave the game at any time.  You can save your current game state by typing 'save' at any time."
        puts "Are you ready to begin?  You can enter 'y' to begin or 'load' to pull up your last saved game."
    end

    def start
        puts "Good luck, have fun!"
        puts " "
        puts "This word is #{computer_word.length} letters long."
        puts "#{@hint.join(" ")}" 
    end
    
    def player_guess
        puts "Please enter your guess! It's turn number #{turn_number}."
        @current_guess= gets.chomp
        if @current_guess == "save"
            save_game?()
            puts "Game Saved!  You can load this game at a later date"
        elsif @current_guess == "exit"
            puts "Thanks for playing!  Have a great day!"
            exit
        end

        if @current_guess.match /^[a-zA-Z]$/ 
            if @hint.include?(@current_guess) == false && wrong_guesses.include?(@current_guess) == false
            @turn_number+= 1 
            else 
                puts "You've already tried that guess!! Please enter a different character."
            end
        else
            puts "Please only enter  one characters (a-z)."
            player_guess()
        end
    end

    def compare(computer_word, current_guess)
        #correct guess AND not already in the hint 
        if computer_word.include?(current_guess)
            computer_word.each_with_index do |letter, index|
                if letter == current_guess
                    hint[index] = current_guess
                end
            end
        else
            p "Oof, it looks like the word doesn't contain that letter."
            wrong_guesses.push(current_guess)
        end
    end
    
    def player_win?(hint)
        if hint == computer_word
            return true
        else 
            return false
        end
    end

    def round()
        start_select = gets.chomp
        if start_select == "load"
            puts "Game Loaded!"
            load_game()
        elsif start_select == "y"
            start()
            game_play()
        else
            puts "Enter 'load' or 'y'"
            round()
        end
    end

    def game_play()

        until @win == true || wrong_guesses.length > 5
            player_guess()
            compare(@computer_word, @current_guess)
            @win = player_win?(@hint)
            p "Current Word:" +"  " + hint.join(" ")
            p "Incorrect Guesses:" +"  " + wrong_guesses.join(", ")
        end
        if @win == true
            p "Wow, you did it! The word was '#{@computer_word.join("")}.'"
            play_again?()
        end

        if @win ==false
            p "Bummer, you ran out of guesses! The word was '#{@computer_word.join("")}' Would you like to play again?"
            play_again?()
        end
    end

    def play_again?()
        p "Would you like to play again?  Please enter y/n."
        play_again = gets.chomp.downcase
        if play_again== "y"
            initialize()
            game_play()
        elsif play_again == "n"
            p "Thanks for playing.  Have a great day!"
        else
            p "Please type either 'y' or 'n'."
            play_again?()
        end
    end
 
    def save_game?()
        save_file_name= "save_state.txt"
        save_file = File.open(save_file_name, "w")
        save_file.puts YAML.dump($game)
        save_file.close
    end

    def load_game()
        save_file = File.open("save_state.txt", 'r')
        $game = YAML.load(save_file, permitted_classes: [Game])
        save_file.close
        p "Current Word:  #{$game.hint.join(" ")}"
        p "Wrong Guesses:  #{$game.wrong_guesses.join("")}"
        $game.game_play()
    end

end
