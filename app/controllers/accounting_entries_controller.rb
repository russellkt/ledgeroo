class AccountingEntriesController < ApplicationController
  before_filter :get_account
  
  # GET /accounting_entries
  # GET /accounting_entries.xml
  def index
    @accounting_entries = @account.accounting_entries.find(:all, :include => :accounting_transaction)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @accounting_entries.to_xml }
    end
  end

  # GET /accounting_entries/1
  # GET /accounting_entries/1.xml
  def show
    @accounting_entry = AccountingEntry.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @accounting_entry.to_xml }
    end
  end

  # GET /accounting_entries/new
  def new
    @accounting_entry = AccountingEntry.new
  end

  # GET /accounting_entries/1;edit
  def edit
    @accounting_entry = AccountingEntry.find(params[:id])
  end

  # POST /accounting_entries
  # POST /accounting_entries.xml
  def create
    @accounting_entry = AccountingEntry.new(params[:accounting_entry])

    respond_to do |format|
      if @accounting_entry.save
        flash[:notice] = 'AccountingEntry was successfully created.'
        format.html { redirect_to accounting_entry_url(@accounting_entry) }
        format.xml  { head :created, :location => accounting_entry_url(@accounting_entry) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @accounting_entry.errors.to_xml }
      end
    end
  end

  # PUT /accounting_entries/1
  # PUT /accounting_entries/1.xml
  def update
    @accounting_entry = AccountingEntry.find(params[:id])

    respond_to do |format|
      if @accounting_entry.update_attributes(params[:accounting_entry])
        flash[:notice] = 'AccountingEntry was successfully updated.'
        format.html { redirect_to accounting_entry_url(@accounting_entry) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @accounting_entry.errors.to_xml }
      end
    end
  end

  # DELETE /accounting_entries/1
  # DELETE /accounting_entries/1.xml
  def destroy
    @accounting_entry = AccountingEntry.find(params[:id])
    @accounting_entry.destroy

    respond_to do |format|
      format.html { redirect_to accounting_entries_url }
      format.xml  { head :ok }
    end
  end
  private
  def get_account
    @account = Account.find(params[:account_id])
  end
end
