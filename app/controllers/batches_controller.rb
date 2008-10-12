class BatchesController < ApplicationController
  
  before_filter :load_batch,     :except => [:index]
  before_filter :load_batches,   :only   => [:index]
  before_filter :setup,          :only   => [:show]
  before_filter :load_new_check, :only   => [:show]

  protected
  def load_batch
    @batch   = Batch.find_by_id(params[:id], :include => { :accounting_transactions => { :accounting_entries => :account } } )
    @batch ||= Batch.new(params[:batch])
    @todays_date = Date.today.strftime("%Y-%m-%d")
  end

  def load_batches
    @batches = Batch.find(:all, :order => 'date DESC, created_at DESC' )
  end
  
  def setup
    @bank_accounts = Account.bank_accounts
    @expense_accounts = Account.expense_accounts
  end
  
  def load_new_check
    if params[:check] 
      @check = AccountingTransaction.build(params[check])
      @check.accounting_entries << AccountingEntry.new
    else
      @check = AccountingTransaction.new( :transaction_type => 'check' )  
      @entry = AccountingEntry.new
    end
  end

  public
  
  def index
  end

  def new
  end
  
  def show
  end

  def create
    if @batch.save
      flash[:notice] = "Batch started."
      redirect_to batch_path(@batch)
    else
      flash.now[:error] = "Problem creating the batch."
      render :action => 'new'
    end
  end
  
  def import_claim_checks
    @batch.import_claim_checks
    if @batch.save
      flash[:notice] = "Claim checks were successfully imported"
      redirect_to batch_url(@batch)
    else
      flash.now[:error] = "Unable to import claim checks"
      render :action => 'show'
    end
  end
  
  def import_legacy_checks
    @batch.import_legacy_checks
    if @batch.save
      flash[:notice] = "Legacy checks were successfully imported"
      redirect_to batch_url(@batch)
    else
      flash.now[:error] = "Unable to import legacy checks"
      render :action => 'show'
    end
  end

  def finalize
    @batch.finalized = true
    if @batch.save
      flash[:notice] = "Batch was finalized."
    else
      flash[:error] = "Batch could not be finalized."
    end
    redirect_to batch_path( @batch )
  end
end
