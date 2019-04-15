class Player
  attr_reader :name, :cards_hand

  def initialize(name)
    @name = name
    @cards_hand = []
  end

  def skip

  end

  def add_card(card)
    @cards_hand << card
  end

  def open_cards

  end
end
