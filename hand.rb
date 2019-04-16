class Hand
  attr_accessor :cards_hand, :score

  def initialize
    @score = 0
    @cards_hand = []
  end

  def start_card(card)
    @cards_hand = card
  end

  def add_card(card)
    @cards_hand << card if @cards_hand.size <= 2   
  end

  def open_cards
    @cards_hand.each { |card| card.to_s  }
  end

  def reset_cards
    @cards_hand.clear
    @score = 0
  end

  def bust?
    true if @score > 21
  end

  def max_cards
    @cards_hand.size == 3
  end

  def black_jack
    @score == 21
  end

  def count_scores
    @score = 0
    @cards_hand.flatten.each do |card|
      if card.picture.is_a?(String) && card.picture != 'A'
        @score += 10
      elsif card.picture == 'A'
        @score <= 10 ? @score += 11 : @score += 1
      else  
        @score += card.picture
      end
    end
  end
end

