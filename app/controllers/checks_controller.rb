class ChecksController < ApplicationController

  before_filter :setup, :only => [:new, :create, :edit, :update] 
  before_filter :load_batch

  protected
  def load_batch
    @batch = Batch.find_by_id(params[:batch_id])
  end

  public
  
  def index
    add_to_sortable_columns 'list', AccountingTransaction
    conditions = {}
    conditions[params[:which]] = params[:q] if params[:which] && params[:q]
    @checks = AccountingTransaction.find_checks :page => params[:page], :conditions => conditions, :order => sortable_order('list', AccountingTransaction, 'document_number')
    respond_to do |format|
      format.html
    end
  end
  
  def setup
    @bank_accounts = Account.bank_accounts
    @expense_accounts = Account.expense_accounts
  end
  
  def new
    @check = AccountingTransaction.new( :transaction_type => 'check' )
    @entries = []
    10.times do |i|
      @entries[i] = AccountingEntry.new
    end
    @credit_entry = @entries.pop
  end 
  
  def create
    params[:check][:transaction_type] = 'check'
    @check = AccountingTransaction.new( params[:check] )
    respond_to do |format|
      if @check.save
        flash[:notice] = 'Check was successfully posted.'
        format.html { redirect_to( create_success_url( params[:commit] ) ) }
        format.xml  { head :created, :location => check_url(@check) }
      else
        flash[:error] = 'Check could not be saved'
        format.html { create_failure_action( params[:commit] ).call }
        format.xml  { render :xml => @check.errors.to_xml }
      end
    end
  end 
  
  def show
    @check = AccountingTransaction.find(params[:id])
    respond_to do |format|
      format.html { }
      format.xml  { render :xml => @check.to_xml }
    end
  end
  
  def edit
    @check = AccountingTransaction.find(params[:id])
    @entries = @check.debit_entries
    @credit_entry = @check.credit_entries.pop
  end
  
  def update
    @check = AccountingTransaction.find( params[:id] )
    respond_to do |format|
      if @check.update_attributes( params[:check] )
        map_entries
        flash[:notice] = 'Check was successfully updated.'
        format.html { redirect_to( post_update_check_url(@check) ) }
        format.xml  { head :created, :location => check_url(@check) }
      else
        map_entries
        flash.now[:error] = 'Unable to update check.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @check.errors.to_xml }
      end
    end
  end
  
  def void
    @check = AccountingTransaction.find(params[:id])
    @check.void
    respond_to do |format|
      if @check.void  
        flash[:notice] = 'Successfully voided check'
        format.html { redirect_to( post_update_check_url(@check) ) }
      else
        flash.now[:error] = 'Unable to void check'
        render :action => 'edit'
      end
    end
  end
  
  def destroy
    @check = AccountingTransaction.find( params[:id] )
    @check.destroy
    respond_to do |format|
      flash[:notice] = 'Check has been successfully deleted'
      format.html { redirect_to batch_url( @check.batch ) }
    end
  end
  
  def print
    @check = AccountingTransaction.find(params[:id], :include => 'accounting_entries')
    respond_to do |format|
      format.html
      format.pdf do
        send_data( CheckPrinter.new.print(@check), 
                   :filename => "#{@check.document_number}.pdf", 
                   :type => 'application/pdf', 
                   :disposition => 'inline' )
      end
    end
  end
  
  protected
  
  def map_entries
    @check ||= AccountingTransaction.new( :transaction_type => 'check' )
    @credit_entry = @check.credit_entries.pop
    @entries = @check.debit_entries
  end
  
  def create_success_url commit_param
    commit_param ||= 'Save'
    success_urls = { 'Save and new'     => new_check_url,
                     'Save'             => check_url(@check),
                     'Save batch check' => batch_url(@check.batch) 
                   }
    success_urls[commit_param]
  end
  
  def create_failure_action commit_param
    #TODO figure out a way to retain attributes rather than create new
    commit_param ||= 'Save'
    failure_actions = { 'Save batch check' => lambda{ redirect_to( batch_url(@check.batch) ) },
                        'Save and new'     => lambda{ redirect_to( new_check_url ) },
                        'Save'             => lambda{ redirect_to( new_check_url ) }
                      }
    failure_actions[commit_param]
  end
  
  def post_update_check_url check
    @check.batch && !@check.batch.is_finalized? ? batch_url(check.batch) : checks_url
  end
end
