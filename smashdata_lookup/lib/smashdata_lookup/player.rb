class SmashdataLookup::Player 
    attr_reader :name, :set_count, :game_count, :main, :tourneys, :placements, :opponents, :scores
    def initialize(name,stats,tourneys,opponents)
        @name = name 
        @set_count = stats[0]
        @game_count = stats[1]
        @main = stats[2]
        @tourneys = tourneys[0]
        @placements = clean_placements(tourneys[1])
        @opponents = opponents[0]
        @scores = opponents[1]
    end

    def puts_info 
        puts "-----------------------------"
        puts "Player: #{name}"
        puts "Set Count: #{set_count}"
        puts "Game Count: #{game_count}"
        puts "Main: #{main}"
        puts "-----------------------------"
    end

    def puts_tourneys(tourneys_array)
        puts "-----------------------------"
        tourneys_array.each do |tourney|
            break if tourneys[tourney] == nil
            puts "Tourney: " + tourneys[tourney]
            puts "Placement: " + placements[tourney]
        end
        puts "-----------------------------"
    end

    def puts_specific_tourneys(placement)
        puts "-----------------------------"
        tourneys.each_with_index do |tourney,index|
            if placements[index].split("/")[0] == placement
                puts "Tourney: " + tourney
                puts "Placement: " + placements[index]
            end
        end
        puts "-----------------------------"
    end

    def puts_sets(sets)
        puts "-----------------------------"
        sets.each do |set|
            break if scores[set] == nil
            if scores[set]!="DQ"
                puts "#{name} #{scores[set]} #{opponents[set]}"    
            else  
                puts "#{name}   #{scores[set]}  #{opponents[set]}"
            end
        end
        puts "-----------------------------"
    end

    def puts_specific_sets(player)
        puts "-----------------------------"
        opponents.each_with_index do |opponent,index|
            break if scores[index] == nil 
            if opponent.downcase == player.downcase
                puts "#{name} #{scores[index]} #{opponent}"
            end
        end
        puts "-----------------------------"
    end

    def clean_placements(placements)
        new_placements = []
        placements.each_with_index do |placement,index|
            index % 2 == 0 ? new_placements << placement.to_s : new_placements[index/2] = new_placements.last + placement.to_s       
        end
        @placements = new_placements
    end

    def compare_results(player)
        puts "-----------------------------"
        tourneys.each_with_index do |tourney,index|
            if player.tourneys.include?(tourney)
                puts "Tourney: " + tourney
                puts "#{player.name}'s Placement: " + player.placements[player.tourneys.find_index(tourney)]
                puts "#{@name}'s Placement: " + @placements[index]
            end
        end
        puts "-----------------------------"
    end

end