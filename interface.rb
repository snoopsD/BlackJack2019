class Interface

  def welcome
    system 'clear'
    puts "Добро пожаловать в игру BlackJack" 
  end

  def ask_name
    puts "Введите ваше имя: "
  end

  def player_cards   
    puts "Карты игрока и количество очков:"
  end

  def dealer_cards
    puts "Карты дилера и количество очков:"
  end

  def dealer_turn
    puts "Ход дилера"
  end

  def dealer_take_card
    puts "Дилер взял карту"
  end

  def dealer_skip_turn
    puts "Дилер пропускает ход"
  end

  def max_cards
    puts "Больше карт нельзя взять"
  end 

  def dealer_win
    puts "Дилер выйграл. Сумма денег: "
  end

  def player_win
    puts "Игрок выйграл. Сумма денег: "
  end

  def draw
    puts "Ничья"
  end

  def no_money
    puts "У игрока недостаточно денег для продолжения игры" 
  end

  def play_again
    puts
    puts "Сыграть еще раз? 1.Да 2.Нет"
  end
end

