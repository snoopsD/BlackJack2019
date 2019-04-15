class Player
  attr_reader :name, :cards_hand, :score

  def initialize(name)
    @name = name
    @cards_hand = []    
  end

  def skip_turn

  end

  def add_card(card)
    @cards_hand = card
  end

  def open_cards

  end

  def count_scores
    @score = 0
    @cards_hand.each do |card|
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
