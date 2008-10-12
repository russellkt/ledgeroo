class AccountingTransactionsController < ApplicationController
  # GET /accounting_transactions
  # GET /accounting_transactions.xml
  def index
    @accounting_transactions = AccountingTransaction.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @accounting_transactions.to_xml }
    end
  end

  # GET /accounting_transactions/1
  # GET /accounting_transactions/1.xml
  def show
    @accounting_transaction = AccountingTransaction.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @accounting_transaction.to_xml }
    end
  end

  # GET /accounting_transactions/new
  def new
    @accounting_transaction = AccountingTransaction.new
  end

  # GET /accounting_transactions/1;edit
  def edit
    @accounting_transaction = AccountingTransaction.find(params[:id])
  end

  # POST /accounting_transactions
  # POST /accounting_transactions.xml
  def create
    @accounting_transaction = AccountingTransaction.new(params[:accounting_transaction])

    respond_to do |format|
      if @accounting_transaction.save
        flash[:notice] = 'AccountingTransaction was successfully created.'
        format.html { redirect_to accounting_transaction_url(@accounting_transaction) }
        format.xml  { head :created, :location => accounting_transaction_url(@accounting_transaction) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @accounting_transaction.errors.to_xml }
      end
    end
  end

  # PUT /accounting_transactions/1
  # PUT /accounting_transactions/1.xml
  def update
    @accounting_transaction = AccountingTransaction.find(params[:id])
    
    respond_to do |format|
      if @accounting_transaction.update_attributes(params[:accounting_transaction])
        flash[:notice] = 'AccountingTransaction was successfully updated.'
        format.html { redirect_to accounting_transaction_url(@accounting_transaction) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @accounting_transaction.errors.to_xml }
      end
    end
  end

  # DELETE /accounting_transactions/1
  # DELETE /accounting_transactions/1.xml
  def destroy
    @accounting_transaction = AccountingTransaction.find(params[:id])
    @accounting_transaction.destroy

    respond_to do |format|
      format.html { redirect_to accounting_transactions_url }
      format.xml  { head :ok }
    end
  end
end
