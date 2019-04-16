require_relative 'player.rb'
require_relative 'card.rb'
require_relative 'bank.rb'
require_relative 'deck.rb'
require_relative 'hand.rb'
require_relative 'interface.rb'

class Main
  attr_reader :deck, :interface

  def initialize
    @deck = Deck.new
    @bank = Bank.new
    @dealer = Player.new('Dealer')
    @interface = Interface.new
  end

  def run
    interface.welcome
    interface.ask_name
    user_name
    new_game
  end

  def new_game
    loop do
      begin_games
      middle_game
    end
  end

  def actions
    actions = [
      '1. Пропустить ход',
      '2. Добавить карту',
      '3. Открыть карты',
      '0. Выйти'
    ]
    actions.each { |action| puts action }
  end

  def exec_actions(action)
    options = {
      0 => :exit, 1 => :skip_player_turn, 2 => :player_turn,
      3 => :show_cards
    }
    system 'clear'
    send options[action]
  end

  def user_name
    name = gets.chomp
    @player = Player.new(name)
  rescue RuntimeError => e
    puts e.inspect
    user_name
  end

  def begin_games
    system 'clear'
    players_bet
    @player.hand.start_card(@deck.cards.sample(2))
    @dealer.hand.start_card(@deck.cards.sample(2))
    compare_cards
    interface.player_cards
    interface.show_player_scores(@player)
  end

  def middle_game
    loop do
      actions
      choice = gets.to_i
      exec_actions(choice)
    end
  end

  def skip_player_turn
    interface.dealer_turn
    if @dealer.hand.score < 17
      @dealer.hand.add_card(@deck.cards.sample(1))
      interface.dealer_take_card
    else
      interface.dealer_skip_turn
    end
    compare_cards
  end

  def player_turn
    if @player.hand.max_cards
      interface.max_cards
    else
      @player.hand.add_card(@deck.cards.sample(1))
    end
    puts @player.hand.open_cards
    compare_cards
  end

  def scores
    @player.hand.count_scores
    @dealer.hand.count_scores
  end

  def players_bet
    @player.bank_bet
    @dealer.bank_bet
    @bank.win_bank(@player.bet + @dealer.bet)
  end

  def compare_cards
    scores
    if @player.hand.bust?
      show_cards
    elsif @player.hand.max_cards && @dealer.hand.max_cards
      show_cards
    elsif @player.hand.black_jack || @dealer.hand.black_jack
      show_cards
    end
  end

  def show_cards
    system 'clear'
    interface.player_cards
    interface.show_player_scores(@player)
    interface.dealer_cards
    interface.show_dealer_scores(@dealer)
    who_win
    retry_again
  end

  def who_win
    if @player.hand.score < @dealer.hand.score || @player.hand.bust?
      @dealer.bank_player += @bank.drop_bank
      interface.dealer_win
      puts @dealer.bank_player
    elsif @player.hand.score > @dealer.hand.score
      @player.bank_player += @bank.drop_bank
      interface.player_win
      puts @player.bank_player
    else
      interface.draw
      drop
    end
  end

  def drop
    @bank.drop_bank
    @player.bank_player += @player.bet
    @dealer.bank_player += @dealer.bet
  end

  def retry_again
    if @player.bank? || @dealer.bank?
      interface.no_money
      exit
    end
    interface.play_again
    user_choice = gets.to_i
    case user_choice
    when 1
      begin_games
    else
      exit
    end
  end
end

Main.new.run

