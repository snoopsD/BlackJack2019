require_relative 'player.rb'
require_relative 'card.rb'
require_relative 'bank.rb'
require_relative 'deck.rb'

class Main
  attr_reader :deck
  
  def initialize 
    @deck = Deck.new
    @bank = Bank.new
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
    call_action(options[action])
  end

  def welcome
    puts "Добро пожаловать в игру BlackJack"
    puts "Введите ваше имя: "
    name = gets.chomp
    @player = Player.new(name)
    @dealer = Player.new('Dealer')
    @player.start_card(@deck.cards.sample(2))
    @dealer.start_card(@deck.cards.sample(2))
    puts "Здравствуйте, #{name}, на вашем счету #{@player.bank_player}"
  end

  def begin_game
    puts "Ваши карты: "
    puts @player.open_cards
    scores
    puts "Сумма ваших очков: #{@player.score}"  
    puts "На вашем счету #{@player.bank_player}"
  end

  def skip_player_turn
    puts "Ход дилера"
    if @dealer.score < 17
      @dealer.add_card(@deck.cards.sample(1)) 
      puts "Дилер взял карту"
      scores
    else
      puts "Дилер пропускает ход"
      skip_dealer_turn
    end 
    compare_cards
  end

  def skip_dealer_turn
    puts "Ход игрока"
    player_turn
  end

  def player_turn
    @player.add_card(@deck.cards.sample(1))
    scores
    compare_cards
  end

  def show_cards
    puts @player.open_cards
    puts "Количество очков игрока: #{@player.score}"
    puts @dealer.open_cards
    puts "Количество очков дилера: #{@dealer.score}"
    if @player.score < @dealer.score 
      puts "Дилер выйграл"
      @dealer.bank_player += @bank.drop_bank
    elsif @player.score > @dealer.score
      puts "Вы победили"
      @player.bank_player += @bank.drop_bank
      puts "У вас в банке #{player.bank_player}"
    else
      puts "Ничья"
      @bank.drop_bank
      @player.bank = @player.bet
      @dealer.bank = @dealer.bet
    end
  end

  private

  def scores
    @player.count_scores
    @dealer.count_scores
    @player.bank_bet
    @dealer.bank_bet
    @bank.win_bank(@player.bet+@dealer.bet)
  end

  def compare_cards
    if (@player.cards_hand.size == 3 && @dealer.cards_hand == 3)
      show_cards
    else 
     return
    end
  end

  def call_action(method)
    send(method)
  rescue RuntimeError => e
    puts e.inspect
  end
end

start = Main.new
start.welcome
start.begin_game

loop do  
  start.actions
  user_action = gets.to_i
  start.exec_actions(user_action)
end
