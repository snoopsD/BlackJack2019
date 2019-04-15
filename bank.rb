class Bank
  attr_accessor :all_bank

  def initialize
    @all_bank = 0
  end

  def win_bank(value)
    @all_bank += value
  end

  def drop_bank
    value = 0
    @all_bank, value = value, @all_bank
    value
  end
end
