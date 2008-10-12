require 'pdf/writer'
require 'pdf/simpletable'
require 'linguistics'

class CheckPrinter
  Linguistics::use( :en )
  include ActionView::Helpers::NumberHelper
  def print check
    pdf = PDF::Writer.new :paper => [0,0,610,489] 
    pdf.select_font 'Courier'
    pdf.add_text_wrap 22,183,100,check.recorded_on.strftime('%m/%d/%Y')
    memo = check.memo ? check.memo : 'check'
    pdf.add_text_wrap 92,183,300,memo
    pdf.add_text_wrap 484,183,100,number_to_currency(check.total_credits),nil,:right
    pdf.y = 388
    render_info_table pdf,check
    pdf.y = 330
    render_payee pdf,check
    pdf.render
  end
  def money_in_words amount
    in_words = []
    numbers = amount.to_s.split('.')
    in_words << dollars(numbers[0])
    in_words << "AND #{cents(numbers[1])}/100"
    in_words.join(' ').upcase + " DOLLARS"
  end
  def dollars amount_string
    amount_string.en.numwords({:and => ' ', :comma => ' '})
  end
  def cents amount_string
    amount_string ||= '0'
    amount_string.length < 2 ? "#{amount_string.slice(0,1)}0" : amount_string.slice(0,2)
  end
  private
  def render_payee pdf,check
    table = PDF::SimpleTable.new
    table.data = [ { "payee" => check.name } ]
    table.column_order = ["payee"]
    table_column table,"payee",312
    table.show_headings = false
    table.shade_rows = :none
    table.show_lines = :none
    table.orientation = :right
    table.position = 86
    table.render_on(pdf)
  end
  
  def render_info_table pdf, check
    table = PDF::SimpleTable.new
    table.data = [ { "date"            => check.recorded_on.strftime('%m/%d/%Y'),
                     "number"          => check.document_number.to_s,
                     "amount_in_words" => "*** #{money_in_words(check.total_credits)} ***",
                     "amount"          => number_to_currency(check.total_credits)
                   } ]
    table.column_order = ["date","number","amount_in_words","amount"]
    table_column table,"date",83
    table_column table,"number",53
    table_column table,"amount_in_words",312
    table_column table,"amount",100,:right
    table.show_headings = false
    table.shade_rows = :none
    table.show_lines = :none
    table.orientation = :right
    table.position = 36
    table.render_on(pdf)              
  end
  def table_column table, name, width, justification = :left
    table.columns[name] = PDF::SimpleTable::Column.new(name) { |col| 
      col.width = width
      col.justification = justification
    }
  end
end
