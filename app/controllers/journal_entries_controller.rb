class JournalEntriesController < ApplicationController
  before_filter :setup, :only => [:new, :create, :edit, :update] 
  def index
    @journal_entries = AccountingTransaction.find_all_by_transaction_type('journal entry', :order => 'document_number' )
  end
  def setup
    get_accounts
  end
  def new
    @journal_entry = AccountingTransaction.new( :transaction_type => 'journal entry' )
    @entries = []
    15.times do |i|
      @entries[i] = AccountingEntry.new
    end
  end
  def create
    @journal_entry = AccountingTransaction.new( params[:journal_entry] )
    @journal_entry.transaction_type = 'journal entry'
    @entries = []
    params[:entries].each{|e| 
      @entries << AccountingEntry.new(e) unless( e['debit'].blank? && e['credit'].blank? ) 
    }
    @journal_entry.accounting_entries = @entries
    @entries << AccountingEntry.new
    @entries << AccountingEntry.new
    respond_to do |format|
      if @journal_entry.save
        flash[:notice] = 'Journal Entry was successfully posted.'
        format.html { redirect_to journal_entries_url }
        format.xml  { head :created, :location => journal_entry_url(@check) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @journal_entry.errors.to_xml }
      end
    end
  end
  def show
    @journal_entry = AccountingTransaction.find(params[:id])
    respond_to do |format|
      format.html { }
      format.xml  { render :xml => @journal_entry.to_xml }
    end
  end
  def edit
    @journal_entry = AccountingTransaction.find(params[:id], :include=>'accounting_entries')
    @entries = @journal_entry.accounting_entries
  end
  def update
    @journal_entry = AccountingTransaction.find( params[:id], :include=>'accounting_entries' )
    @journal_entry.attributes = params[:journal_entry]
    if is_balanced?(params)
      @journal_entry.accounting_entries.update(params[:entries].keys, params[:entries].values)
    else
      @journal_entry.add_unbalanced_error( total_debits(params), total_credits(params) )
    end
    @entries = @journal_entry.accounting_entries
    respond_to do |format|
      if is_balanced?(params) && @journal_entry.save
        flash[:notice] = 'Journal was successfully updated and posted.'
        format.html { redirect_to(journal_entry_url(@journal_entry)) }
        format.xml  { head :created, :location => journal_entry_url(@journal_entry) }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @journal_entry.errors.to_xml }
      end
    end
  end
  
  private
  def get_accounts
    @accounts = Account.map_for_select( // )
  end
  def total_debits params
    params[:entries].values.inject(0){|debits,e| debits + e['debit'].to_f }
  end
  def total_credits params
    params[:entries].values.inject(0){|credits,e| credits + e['credit'].to_f }
  end
  def is_balanced? params
    (total_debits(params) - total_credits(params)).abs < 0.001
  end
end
