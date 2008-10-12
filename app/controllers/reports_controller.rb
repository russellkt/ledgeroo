class ReportsController < ApplicationController
  helper :all
  
  def index
  end

  def transaction
    @from = params[:from] || Time.now.last_month.beginning_of_month.to_date
    @to   = params[:to]   || Time.now.last_month.end_of_month.to_date
    if request.post? || params[:format]
      # Run the report
      @accounting_transactions = AccountingTransaction.find(:all, :include => [:accounting_entries]) do
        recorded_on <=> [params[:from], params[:to]]
      end
      respond_to do |format|
        format.html{
          render :action => 'transaction_report' and return
        }
        format.csv{
          render :action => 'transaction_report' and return
        }
      end
    end
  end
  
  def positive_pay    
    @accounting_entries = AccountingEntry.find( :all, :include => [:account, :accounting_transaction] ) do
      accounting_transaction.created_at > params[:from]
      account.number == params[:account_number]
      accounting_transaction.transaction_type == 'check'
      accounting_transaction.is_void == ''
    end
    respond_to do |format|
      format.html{
        render :action => 'positive_pay_report' and return
      }
      format.csv{
        render :action => 'positive_pay_report' and return
      }
    end
  end
  
  def checks
    @from = params[:from] || Time.now.last_month.beginning_of_month.to_date
    @to   = params[:to]   || Time.now.last_month.end_of_month.to_date
    if request.post? || params[:format]
      # Run the report
      @checks = AccountingTransaction.find(:all, :include => [:accounting_entries], :order => 'document_number ASC') do
        recorded_on <=> [params[:from], params[:to]]
        transaction_type =~ 'check'
      end
      respond_to do |format|
        format.html{
          render :action => 'checks_report' and return
        }
        format.csv{
          render :action => 'checks_report' and return
        }
      end
    end
  end
  
end
