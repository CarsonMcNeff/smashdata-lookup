class SmashdataLookup::Scraper 
    attr_accessor :url, :player, :game

    def initialize(player,game)
        player_clean = player.split(" ").collect(&:capitalize).join("%20")
        @game = game.downcase
        @url = "https://smashdata.gg/smash/#{@game}/player/#{player_clean}"
        @url = check_url(url)
        if url != "https://smashdata.gg" 
            player_stats = get_player_stats()
            player_tourneys = get_player_tourneys()
            player_opponents = get_player_opponents()

            if @game == "melee"
                name = url[40..-1].split(/[?&]/)[0].gsub("%20"," ")
            else
                name = url[43..-1].split(/[?&]/)[0].gsub("%20"," ")
            end
            @player = SmashdataLookup::Player.new(name,player_stats,player_tourneys,player_opponents)
        else
            puts "Player does not exist, restarting."
            SmashdataLookup::CLI.new.call_with_game(@game)
        end
    end

    def check_url(url)
        begin 
            smash_page = Nokogiri::HTML(open(url))
            if @game == "melee" 
                testsafe =  smash_page.css("div.portrait-container").css("img").attribute("src").to_s[31..-7].capitalize
            else
                testsafe =  smash_page.css("div.portrait-container").css("img").attribute("src").to_s[34..-7].capitalize
            end
            url
        rescue Exception => ex
            "https://smashdata.gg" + smash_page.css("td").css("a").attribute("href").to_s.gsub(" ","%20")
        end
    end

    def get_player_stats
        begin
            smash_page = Nokogiri::HTML(open(url))
            set_count = smash_page.css("h4#set-count").text
            game_count = smash_page.css("h4#game-count").text
            if @game == "melee"
                main = smash_page.css("div.portrait-container").css("img").attribute("src").to_s[31..-7].capitalize
            else  
                main = smash_page.css("div.portrait-container").css("img").attribute("src").to_s[34..-7].capitalize
            end
            [set_count, game_count, main]
        rescue Exception => ex 
            puts "Player may not have enough activity to have a valid search, restarting."
            SmashdataLookup::CLI.new.call
        end
    end

    def get_player_tourneys
        smash_page = Nokogiri::HTML(open(url))

        tourneys = smash_page.css("td.name-rank").collect{|a|a.text.strip.split("  ")[0]}.to_a
        placements = smash_page.css("td.placing").children.collect{|a|a.text.strip}.select{|a|a != ""}

        [tourneys, placements]
    end

    def get_player_opponents
        smash_page = Nokogiri::HTML(open(url))

        opponents = smash_page.css("a.player-link").collect{|a|a.text.strip}.to_a
        scores = smash_page.css("span.right").collect{|a|a.text.strip}.to_a - ["Score", "Placing/ Entrants"]

        [opponents, scores]
    end
end