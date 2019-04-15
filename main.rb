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
    system 'clear'
    puts "Добро пожаловать в игру BlackJack"
    puts "Введите ваше имя: "
    name = gets.chomp
    @player = Player.new(name)
    @dealer = Player.new('Dealer') 
  end

  def begin_game
    players_bet
    @player.start_card(@deck.cards.sample(2))
    @dealer.start_card(@deck.cards.sample(2))
    puts "Ваши карты: "
    puts @player.open_cards
    compare_cards
    puts "Сумма ваших очков: #{@player.score}"  
    puts "На вашем счету #{@player.bank_player}"
  end

  def skip_player_turn
    scores
    puts "Ход дилера"
    if @dealer.score < 17
      @dealer.add_card(@deck.cards.sample(1)) 
      puts "Дилер взял карту"
    else
      puts "Дилер пропускает ход. Ход игрока"
    end
    compare_cards
  end

  def player_turn
    compare_cards 
    if @player.max_cards
      puts "Больше карт нельзя брать"
    else
      @player.add_card(@deck.cards.sample(1))
    end  
    puts @player.open_cards       
  end

  def show_cards
    puts @player.open_cards
    puts "Количество очков игрока: #{@player.score}"
    puts @dealer.open_cards
    puts "Количество очков дилера: #{@dealer.score}"
    if @player.score < @dealer.score || @player.bust?
      puts "Дилер выйграл"
      @dealer.bank_player += @bank.drop_bank
    elsif @player.score > @dealer.score
      puts "Вы победили"
      @player.bank_player += @bank.drop_bank
      puts "У вас в банке #{@player.bank_player}"
    else
      puts "Ничья"
      @bank.drop_bank
      @player.bank_player += @player.bet
      @dealer.bank_player += @dealer.bet
    end
    retry_again
  end

  def retry_again
    if @player.bank_player == 0 || @dealer.bank_player == 0
      puts "У игрока недостаточно денег для продолжения игры" 
      exit
    end 
    puts "Сыграть еще раз? 1: Да 2: Нет"
    user_choice = gets.to_i 
    return "Неверный выбор" if user_choice > 2
    case user_choice
    when 1
      begin_game
    when 2
      puts "Спасибо за игру!"
      exit
    end
  end

  private

  def call_action(method)
    send(method)
  rescue RuntimeError => e 
    puts e.inspect 
  end

  def scores
    @player.count_scores
    @dealer.count_scores    
  end

  def players_bet
    @player.bank_bet
    @dealer.bank_bet
    @bank.win_bank(@player.bet+@dealer.bet)
  end

  def compare_cards
    scores
    if @player.bust? 
      show_cards
    elsif @player.max_cards && @dealer.max_cards
      show_cards 
    elsif @player.black_jack || @dealer.black_jack
      show_cards
    end  
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
