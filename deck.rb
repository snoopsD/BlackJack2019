class Deck
  attr_reader :cards
  
  def initialize
    @cards = create_cards
  end   

  def create_cards
    cards = []
    ranks = [*(2..10), 'J', 'Q', 'K', 'A']
    %w(♠ ♥ ♦ ♣).each do |picture|
      ranks.each { |rank| cards <<  [rank, picture] }
    end 
    cards.shuffle!  
  end 
end
