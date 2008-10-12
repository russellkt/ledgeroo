class StatementsController < ApplicationController
  def index
    @statements = Statement.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @statements.to_xml }
    end
  end

  def show
    @statement = Statement.find(params[:id])
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @statement.to_xml }
    end
  end

  def new    
    @accounts = Account.bank_accounts
    @statement = Statement.new
  end

  def edit
    @statement = Statement.find(params[:id])
    
    @cleared_entries = @statement.accounting_entries
    @uncleared_entries = @statement.account.uncleared_entries
  end

  def create
    @statement = Statement.new(params[:statement])

    respond_to do |format|
      if @statement.save
        flash[:notice] = 'Statement was successfully created.'
        format.html { redirect_to statement_url(@statement) }
        format.xml  { head :created, :location => statement_url(@statement) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @statement.errors.to_xml }
      end
    end
  end

  def update
    @statement = Statement.find(params[:id])
    @statement.accounting_entries.map{|e| e.update_attributes(:statement_id=>nil) }
    if entries_ids = params[:entries]
      AccountingEntry.update_all( "statement_id=#{params[:id]}", "id in (#{params[:entries].join(",")})" )
    end
    respond_to do |format|
      if @statement.update_attributes(params[:statement])
        flash[:notice] = 'Statement was successfully updated.'
        format.html { redirect_to params[:commit] =~ /update/i ? edit_statement_url(@statement) : statement_url(@statement)}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @statement.errors.to_xml }
      end
    end
  end

  def destroy
    @statement = Statement.find(params[:id])
    @statement.destroy

    respond_to do |format|
      format.html { redirect_to statements_url }
      format.xml  { head :ok }
    end
  end
end