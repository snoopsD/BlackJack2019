class Player
  attr_reader :name, :hand
  attr_accessor :bank_player

  START_BANK = 100
  BET = 10

  def initialize(name)
    @name = name
    @bank_player = START_BANK
    @hand = Hand.new
    validate!
  end

  def bet
    BET
  end

  def bank_bet
    @bank_player -= BET unless @bank_player.zero?
  end

  def bank?
    @bank_player.zero?
  end

  def validate!
    raise 'Имя не может быть пустым' if @name == ' ' || @name.empty?

    true
  end
end
