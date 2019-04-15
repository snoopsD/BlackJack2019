class Card
  attr_reader :picture, :rank

  def initialize(picture, rank)
    @picture = picture
    @rank = rank
  end

  def to_s
    "#{@picture}#{rank}"
  end 
end
