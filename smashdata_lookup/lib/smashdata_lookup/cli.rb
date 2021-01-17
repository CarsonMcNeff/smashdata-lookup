class SmashdataLookup::CLI
    attr_accessor :scraper, :game
    def call
        validinput = false
        while validinput != true
            puts "Would you like to search for information on Melee players or Ultimate players?"
            input = gets.strip
            if input == "melee" || input == "ultimate"
               @game = input
               validinput = true
            elsif input == "exit"
                exit 
            else  
                puts "Invalid input, try again."
            end
        end
        call_with_game(game)
    end

    def call_with_game(game)
        puts "Enter the #{game.capitalize} player you'd like to find information on."
        puts "Type 'exit' at any time to exit."    
        @game = game
        input = "0"
        while input != "exit"
            input = gets.strip
            exit if input == "exit"
            @scraper = SmashdataLookup::Scraper.new(input,game)
            further
        end
    end

    def further   
        input = "0"
        @scraper.player.puts_info
        while input != "exit"
            puts "Commands List:"
            puts "1. See #{@scraper.player.name}'s #{game.capitalize} Tournaments"
            puts "2. See #{@scraper.player.name}'s #{game.capitalize} Sets"
            puts "3. See #{@scraper.player.name}'s #{game.capitalize} Stats Again"
            puts "4. Search For A New #{game.capitalize} Player"
            puts "5. Change Games"
            puts "6. Exit Program"
            puts "-----------------------------"
            input = gets.strip
            if input == "1"
                tourney_display()
            elsif input == "2"
                sets_display()
            elsif input == "3"
                @scraper.player.puts_info()
            elsif input == "4"
                SmashdataLookup::CLI.new.call_with_game(game)
            elsif input == "5"
                SmashdataLookup::CLI.new.call_with_game(game == "melee" ? "ultimate" : "melee")
            elsif input == "exit" || input == "6"
                exit
            end
        end   
    end

    def sets_display
        cur_start = 0
        display_amount = 40
        @scraper.player.puts_sets((0..display_amount-1).to_a)
        input = "0"
        while input != "exit"
            puts "Commands List:"
            puts "1. See Next #{display_amount} Sets"
            puts "2. See Previous #{display_amount} Sets"
            puts "3. Search For #{game.capitalize} Set With Specific Player"
            puts "4. Return"
            puts "5. Exit Program"
            puts "-----------------------------"
            input = gets.strip
            if input == "1" || input == "2"
                cur_start -= (input.to_i * 2 - 3) * display_amount
                @scraper.player.puts_sets((cur_start..cur_start+display_amount-1).to_a)
            elsif input == "3"
                puts "Enter the player you'd like to check #{@scraper.player.name}'s #{game.capitalize} sets with."
                input = gets.strip 
                if input == "exit"
                    exit
                else
                    @scraper.player.puts_specific_sets(input)
                end
            elsif input == "4"
                further()
            elsif input == "5" || input == "exit"
                exit
            end
        end
    end

    def tourney_display
        cur_start = 0
        display_amount = 20
        @scraper.player.puts_tourneys((0..display_amount-1).to_a)
        input = "0"
        while input != "exit"
            puts "Commands List:"
            puts "1. See Next #{display_amount} Tournaments"
            puts "2. See Previous #{display_amount} Tournaments"
            puts "3. Search For #{game.capitalize} Tournament With Specific Placement"
            puts "4. Compare #{@scraper.player.name}'s Tournament Results With Another Player"
            puts "5. Return"
            puts "6. Exit Program"
            puts "-----------------------------"
            input = gets.strip
            if input == "1" || input == "2"
                cur_start -= (input.to_i * 2 - 3) * display_amount
                @scraper.player.puts_tourneys((cur_start..cur_start+display_amount-1).to_a)
            elsif input == "3"
                puts "Enter the placement you'd like to check #{@scraper.player.name}'s #{game.capitalize} results for."
                input2 = gets.strip 
                if input2 == "exit"
                    exit
                else
                    @scraper.player.puts_specific_tourneys(input2)
                end
            elsif input == "4"
                puts "Enter the player you'd like to compare #{@scraper.player.name}'s tournament results with."
                input = gets.strip 
                if input == "exit"
                    exit
                else
                    SmashdataLookup::Scraper.new(input,@game).player.compare_results(@scraper.player)
                end
            elsif input == "5"
                further()
            elsif input == "6" || input == "exit"
                exit
            end 
        end
    end
end
