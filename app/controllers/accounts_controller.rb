class AccountsController < ApplicationController
  before_filter :get_accounts, :only=>['index','new','edit']
  # GET /accounts
  # GET /accounts.xml
  def index
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @accounts.to_xml }
    end
  end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    @account = Account.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @account.to_xml }
    end
  end

  # GET /accounts/new
  def new    
    @account = Account.new
    @parent_accounts = Account.map_for_select( // )
  end

  # GET /accounts/1;edit
  def edit   
    @account = Account.find(params[:id])
    @parent_accounts = @account.available_parents.map{|a| [a.number_with_name, a.id]}
  end

  # POST /accounts
  # POST /accounts.xml
  def create
    @account = Account.new(params[:account])

    respond_to do |format|
      if @account.save
        flash[:notice] = 'Account was successfully created.'
        format.html { redirect_to accounts_url }
        format.xml  { head :created, :location => account_url(@account) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors.to_xml }
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    @account = Account.find(params[:id])
    respond_to do |format|
      if @account.update_attributes(params[:account])
        flash[:notice] = 'Account was successfully updated.'
        format.html { redirect_to account_url(@account) }
        format.xml  { head :ok }
      else
        get_accounts
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors.to_xml }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_url }
      format.xml  { head :ok }
    end
  end
  private
  def get_accounts    
    @accounts = Account.find(:all, :include=>["account_type"], :order => "number asc")
    @account_types = AccountType.map_for_select
  end
end
