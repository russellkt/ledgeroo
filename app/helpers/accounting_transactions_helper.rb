module AccountingTransactionsHelper
  def transaction_type_path transaction
    case transaction.transaction_type
    when /check/i
      check_path(transaction)
    else
      journal_entry_path(transaction)
    end
  end
end
