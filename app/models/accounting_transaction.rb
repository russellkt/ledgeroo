
# == Schema Information
# Schema version: 13
#
# Table name: accounting_transactions
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  document_id      :integer
#  document_number  :integer
#  memo             :string(255)
#  recorded_on      :date
#  created_at       :datetime
#  updated_at       :datetime
#  transaction_type :string(255)
#  is_void          :boolean
#  department_id    :integer
#  class_id         :integer
#  location_id      :integer
#  accountable_type :string(255)
#  accountable_id   :integer
#  reversal_id      :integer
#  batch_id         :integer
#

class AccountingTransaction < ActiveRecord::Base
  cattr_reader :per_page
  attr_reader :offsetting_account
  @@per_page = 50

  has_many   :accounting_entries, :dependent => :destroy
  has_many   :accounts,           :through => :accounting_entries
  belongs_to :accountable,        :polymorphic => true
  belongs_to :batch
  validates_presence_of         :document_number
  validates_uniqueness_of       :document_number
  validates_presence_of         :recorded_on
  validates_associated          :accounting_entries
  before_save                   :update_total, :void_if_zero
  before_validation_on_create   :offset_quickie
  after_update                  :save_accounting_entries

  def validate
    add_unbalanced_error( total_debits, total_credits ) unless self.is_balanced?
    errors.add_to_base("No valid entries found.  Please ensure that debit/credit amounts are correct.") unless( has_both_debit_and_credit_entries? )
  end

  def add_unbalanced_error debits, credits
    m = lambda{ |num| MoneyHelper.moneyify(num) }
    errors.add_to_base("Unable to save unbalanced transaction.  Debits = #{m.call(debits)} and Credits = #{m.call(credits)}")
  end

  def has_both_debit_and_credit_entries?
    entries("debit") && entries("credit")
  end

  def is_balanced?
    ( total_credits.to_f - total_debits.to_f ).abs < 0.001
  end

  def total_credits
    credits = self.accounting_entries.inject(0){ |s,e| s + e.credit.to_f }
  end

  def total_debits
    debits = self.accounting_entries.inject(0){ |s,e| s + e.debit.to_f }
  end

  def entries debit_or_credit
    accounting_entries.find( :all, :conditions => "#{debit_or_credit} > 0" )
  end

  def debit_entries
    entries 'debit'
  end

  def credit_entries
    entries 'credit'
  end

  def next_document_number
    max = AccountingTransaction.maximum( :document_number,
                                         :conditions => "transaction_type = '#{self.transaction_type}'"
                                       )
    (max.to_i + 1)
  end

  def void
    self.transaction do
      accounting_entries.map( &:void )
      update_attributes( :is_void => true, :name => '***VOID***' )
    end
  end

  def void_and_reverse
    rt = reversal_transaction
    self.is_void = true
    rt.reversal_id = self.id
    rt.save!
    self.reversal_id = rt.id
    rt
  end

  def reversal_transaction
    rt = AccountingTransaction.new( :transaction_type => 'Reversal',
                                    :accountable_type => self.accountable_type,
                                    :accountable_id   => self.accountable_id )
    rt.document_number = rt.next_document_number
    rt.recorded_on = Date.today
    accounting_entries.each do |entry|
      reversal_entry = entry.reversal_entry
      reversal_entry.accounting_transaction = rt
      rt.accounting_entries << reversal_entry
    end
    rt
  end

  def self.find_checks options={}
    options = { :page => 1 }.merge(options)
    paginate_by_transaction_type('check', { :include => 'accounting_entries',
                                            :order => 'document_number' }.merge(options))
  end

  def editable?
    !(batch && batch.finalized?)
  end

  def update_total
    self.total = self.total_credits
  end

  def new_entry_attributes= entry_attributes
    entry_attributes.each do |e|
      accounting_entries.build(e) if is_valid_entry_attribute?( e )
    end
  end

  def existing_entry_attributes= entry_attributes
    accounting_entries.reject(&:new_record?).each do |entry|
      attributes = entry_attributes[entry.id.to_s]
      if attributes
        entry.attributes = attributes
      else
        accounting_entries.delete(entry)
      end
    end
  end

  def save_accounting_entries
    accounting_entries.each do |entry|
      entry.save(false)
    end
  end

  def displayed_debit_account
    return '' if is_void? 
    account_name = debit_entries.size > 1 ? '** SPLIT **' : debit_entries[0].account.number_with_name
  end

  def displayed_credit_account
    return '' if is_void? 
    account_name = credit_entries.size > 1 ? '** SPLIT **' : credit_entries[0].account.number_with_name
  end

  def is_valid_entry_attribute? entry_attributes
    entry_attributes['credit'].to_f > 0 || entry_attributes['debit'].to_f > 0
  end 

  def offsetting_account= offsetting_account_number
    @offsetting_account = Account.find_by_number( offsetting_account_number.to_i )
  end

  def offset_quickie
    if @offsetting_account 
      offsetting_entry = AccountingEntry.new( :account_id => @offsetting_account.id,
                                              :credit     => total_debits )
      accounting_entries.push offsetting_entry
    end
  end

  def void_if_zero
    void if( total_debits == 0 && total_credits == 0 && !is_void? && transaction_type =~ /check/i )
  end

end