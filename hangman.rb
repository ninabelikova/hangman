require 'yaml'

class Hangman
    def initialize
        content = File.open('5desk.txt', 'r') {|file| file.read}
        valid_words = content.split.select { |word| word.length.between?(5, 12) }
        @word = valid_words.sample.downcase.split('')
        @display = Array.new(@word.length, '_')
        @misses = Array.new
        @turns = 10
    end
    
    def engine
        result = "Tu as perdu ! Le mot était #{@word.join}."
        while @turns > 0
            display
            enter_guess
            if @display.none? {|i| i=='_'}
                result = "#{@display.join(' ')} \nTu as gagné !"
                @turns = 0
            end
        end
        puts result
    end
    
    def display
        @display.each { |i| print "#{i} "}
        puts "\n"
        puts "Misses: #{@misses.join(', ')}."
        puts "Turns remaining: #{@turns}."
    end
    
    def enter_guess
        print 'Enter guess: '
        input = gets.chomp
        puts "\n"
        if input == 'save'
            save_game
            puts 'Sauvegardé.'
        elsif @word.none? { |w| w == input}
            @misses << input
            @turns -= 1
        else
            @word.each_with_index do |letter, i|
                @display[i] = letter if letter == input
            end
        end
    end 
end




def load_game
    content = File.open('saved.yaml', 'r') { |file| file.read }
    YAML.load(content)
end
    
def save_game
    filename = 'saved.yaml'
    File.open(filename, 'w') do |file|
        file.puts YAML.dump(self)
    end
end

def valid_answer(q)
    input = ''
    until input == 'y' || input == 'n'
        print q
        input = gets.chomp
    end
    input
end   

def welcome
    system 'clear'
    puts "Welcome to Nina's professional hangman service!\n"
    input = valid_answer("Do you want to load previously saved game? (y/n) ")
    game = input == 'y' ? load_game : Hangman.new
    game.engine
    input2 = valid_answer("Another game perhaps?\n")
    Hangman.new.engine if input2 == 'y'
end

welcome