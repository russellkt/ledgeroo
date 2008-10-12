class MoneyHelper
  def self.moneyify number
    "$" + sprintf("%.02f", number )
  end
end