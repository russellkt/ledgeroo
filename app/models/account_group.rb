# == Schema Information
# Schema version: 13
#
# Table name: account_groups
#
#  id        :integer         not null, primary key
#  name      :string(255)     
#  is_debit  :boolean         
#  is_credit :boolean         
#

class AccountGroup < ActiveRecord::Base
  has_many :account_types
  has_many :accounts, :through => :account_types
  
  def balance
    account_types.sum{|type| type.balance.to_f}
  end
end
