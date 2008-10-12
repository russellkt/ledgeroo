module SortableColumnHeaders

protected


  def self.included(base)
    base.instance_eval do
      attr_accessor :sortable_column_header_data
      before_filter :init_sortable_column_headers
      helper_method :sort_param, :sortable_data, :sort_param_details
    end
  end


  def add_to_sortable_columns(sortable_name, *args)
    if args.size >= 1
      if args.first.kind_of?(Class)
        model = args.first
        if args.size >= 2
          field = args[1].to_s
          if args.size == 2
            data_name = model.table_name+'.'+field
            self.sortable_column_header_data[assemble_sort_key(sortable_name, data_name)] = data_name
          else args.size == 3
            col_alias = args[2].to_s
            col_alias.chop! if (col_alias[-1].chr == '!')
            data_name = model.table_name+'.'+field
            self.sortable_column_header_data[assemble_sort_key(sortable_name, col_alias)] = data_name
          end
        else
          model.columns.each do |c|
            data_name = model.table_name+'.'+c.name
            self.sortable_column_header_data[assemble_sort_key(sortable_name, data_name)] = data_name
          end
        end

      # BEGIN - The "new" way ...
      elsif args.first.kind_of?(Hash)

        if !args.first[:model].blank? && args.first[:model].kind_of?(Class)
          model = args.first[:model]
          
          if !args.first[:field].blank?

            field = args.first[:field].to_s
            if args.first[:alias].blank?
              data_name = model.table_name+'.'+field
              self.sortable_column_header_data[assemble_sort_key(sortable_name, data_name)] = data_name
              prestore_sort(sortable_name, data_name, self.sortable_column_header_data, *args) unless args.first[:sort_direction].blank?
            else
              col_alias = args.first[:alias].to_s
              col_alias.chop! if (col_alias[-1].chr == '!')
              data_name = model.table_name+'.'+field
              self.sortable_column_header_data[assemble_sort_key(sortable_name, col_alias)] = data_name
              prestore_sort(sortable_name, col_alias, self.sortable_column_header_data, *args) unless args.first[:sort_direction].blank?
            end
          else
            model.columns.each do |c|
              data_name = model.table_name+'.'+c.name
              self.sortable_column_header_data[assemble_sort_key(sortable_name, data_name)] = data_name
              prestore_sort(sortable_name, data_name, self.sortable_column_header_data, *args) unless args.first[:sort_direction].blank?
            end

          end

        elsif !args.first[:field].blank?
          field = args.first[:field].to_s
          if !args.first[:alias].blank?
            col_alias = args.first[:alias].to_s
            col_alias.chop! if (col_alias[-1].chr == '!')
            self.sortable_column_header_data[assemble_sort_key(sortable_name, col_alias)] = field
            prestore_sort(sortable_name, col_alias, self.sortable_column_header_data, *args) unless args.first[:sort_direction].blank?
          else
            self.sortable_column_header_data[assemble_sort_key(sortable_name, field)] = field
            prestore_sort(sortable_name, data_name, self.sortable_column_header_data, *args) unless args.first[:sort_direction].blank?
          end
        else
          raise sch_err_msg
        end
      # END - The "new" way
        
      else
        field = args.first.to_s
        if args.size == 1
          self.sortable_column_header_data[assemble_sort_key(sortable_name, field)] = field
        else
          col_alias = args[1].to_s
          col_alias.chop! if (col_alias[-1].chr == '!')
          self.sortable_column_header_data[assemble_sort_key(sortable_name, col_alias)] = field
        end
      end
    else
      raise sch_err_msg
    end
  end


  def process_sort_param(sortable_name)
    data_sort_asc  = params[:sortasc]
    data_sort_desc = params[:sortdesc]
    data_name = data_sort_asc || data_sort_desc

    unless data_name.blank?
      data_name.strip!

      data_name_parts = data_name.split('-')
      one_part   = data_name_parts.size == 1
      many_parts = data_name_parts.size > 1
      first_part = data_name_parts[0].strip

      if one_part || (many_parts && (first_part == sortable_name))

        data_name = data_name_parts[1].strip if many_parts && (first_part == sortable_name)
        data_name.chop! if (data_name[-1] == '!')
      
        sortable_key = assemble_sort_key(sortable_name, data_name)
        #logger.debug 'SCH sortable_key: '+sortable_key.on_cyan # Make sure you have the colored plugin!
        logger.debug 'SCH sortable_key: '+sortable_key

        store_sort(sortable_name, data_sort_asc, sortable_key, self.sortable_column_header_data)
      end
    end
  end


  def sortable_order(sortable_name, *args)
    if args.size >= 1
      if args.first.kind_of?(Class)
        model = args.first
        if args.size >= 2
          field = args[1].to_s
          data_name = model.table_name+'.'+field
        end
        
      # BEGIN - The "new" way ...
      elsif args.first.kind_of?(Hash)
        
        if !args.first[:sort_direction].blank?
          default_sort_direction = args.first[:sort_direction].to_s.strip.upcase
        end
        
        if !args.first[:model].blank? && args.first[:model].kind_of?(Class)
          model = args.first[:model]
          if !args.first[:field].blank?
            field = args.first[:field].to_s
            data_name = model.table_name+'.'+field
          end
        elsif !args.first[:field].blank? || !args.first[:alias].blank?
          if !args.first[:field].blank?
            field = args.first[:field].to_s
            data_name = field
          end
          if !args.first[:alias].blank?
            col_alias = args.first[:alias].to_s
            col_alias.chop! if (col_alias[-1].chr == '!')
            data_name = col_alias
          end
        else
          raise sch_err_msg
        end
      # END - The "new" way
      
      else
        field = args.first.to_s
        data_name = field
      end
    else
      #raise sch_err_msg
      data_name = 'id'
    end

    process_sort_param(sortable_name)
    sorted_key = assemble_sort_key(sortable_name)
    
    unless session[:sortable_column_headers].nil? || session[:sortable_column_headers][sorted_key].nil?
      return session[:sortable_column_headers][sorted_key].join(',') if session[:sortable_column_headers][sorted_key].size > 0
    end
    # If all went well, then we should have returned by now.  Otherwise, here's a default value ...
    default_sort_direction ||= 'ASC'
    return data_name + ' ' + default_sort_direction
  end


  def sort_param(sortable_name, *args)
    data_name, got_chopped = get_data_name_for_sort_param(sortable_name, *args)

    sortable_key = assemble_sort_key(sortable_name, data_name)
    sorted_key = assemble_sort_key(sortable_name)

    sort_param = 'sortasc'
    unless session[:sortable_column_headers].nil? || session[:sortable_column_headers][sorted_key].nil?

      if sch_key = self.sortable_column_header_data[sortable_key]
        if session[:sortable_column_headers][sorted_key].include?(sch_key+' ASC')
          if session[:sortable_column_headers][sorted_key].index(sch_key+' ASC') == 0
            sort_param = 'sortdesc'
          end
        elsif session[:sortable_column_headers][sorted_key].include?(sch_key+' DESC')
          if session[:sortable_column_headers][sorted_key].index(sch_key+' DESC') > 0
            sort_param = 'sortdesc'
          end
        end
      end

    end
    { sort_param.to_sym => (got_chopped ? data_name : sortable_name+'-'+data_name) }
  end

  def sort_param_details(sortable_name, *args)
    data_name, got_chopped = get_data_name_for_sort_param(sortable_name, *args)
    sortable_key = assemble_sort_key(sortable_name, data_name)
    sorted_key = assemble_sort_key(sortable_name)
    "data_name=#{data_name}, got_chopped=#{got_chopped}, sortable_key=#{sortable_key}, sorted_key=#{sorted_key}"
  end



  def sortable_data
    self.sortable_column_header_data
  end


private

  
  def get_data_name_for_sort_param(sortable_name, *args)
    if args.size >= 1
      if args.first.kind_of?(Class)
        model = args.first
        if args.size >= 2
          field = args[1].to_s
          if args.size == 3
            data_name = args[2].to_s # col_alias
          else args.size == 2
            data_name = model.table_name+'.'+field
          end
        else
          raise sch_err_msg
        end

      # BEGIN - The "new" way ...
      elsif args.first.kind_of?(Hash)

        if !args.first[:model].blank? && args.first[:model].kind_of?(Class)
          model = args.first[:model]
          if !args.first[:field].blank?
            field = args.first[:field].to_s
            data_name = model.table_name+'.'+field
          end
        elsif !args.first[:field].blank? || !args.first[:alias].blank?
          if !args.first[:field].blank?
            field = args.first[:field].to_s
            data_name = field
          end
          if !args.first[:alias].blank?
            col_alias = args.first[:alias].to_s
            if col_alias[-1].chr == '!'
              col_alias.chop!
              got_chopped = true
            end
            data_name = col_alias
          end
        else
          raise sch_err_msg
        end
      # END - The "new" way

      else
        data_name = args.first.to_s
        if data_name[-1].chr == '!'
          data_name.chop!
          got_chopped = true
        end
      end
    else
      raise sch_err_msg
    end
    data_name ||= nil
    got_chopped ||= false
  
    return data_name, got_chopped
  end


  def store_sort(sortable_name, data_sort_param, sortable_key, sch_data)
    if sch_data.include? sortable_key
      if data_sort_param
        sort_sql     = sch_data[sortable_key]+' ASC'
        sort_sql_not = sch_data[sortable_key]+' DESC'
      else
        sort_sql     = sch_data[sortable_key]+' DESC'
        sort_sql_not = sch_data[sortable_key]+' ASC'
      end
      
      sorted_key = assemble_sort_key(sortable_name)
      if session[:sortable_column_headers].nil?
        session[:sortable_column_headers] = { sorted_key => [sort_sql] }
      else
        if session[:sortable_column_headers].include?(sorted_key)
          session[:sortable_column_headers][sorted_key].delete(sort_sql_not)
          session[:sortable_column_headers][sorted_key].delete(sort_sql)
          session[:sortable_column_headers][sorted_key].insert(0,sort_sql)
        else
          session[:sortable_column_headers].store(sorted_key, [sort_sql])
        end
      end
    end
  end


  def prestore_sort(sortable_name, data_name, sch_data, *args)
    default_sort_direction = args.first[:sort_direction].to_s.strip.downcase
    sortable_key = assemble_sort_key(sortable_name, data_name)
    store_sort(sortable_name, (default_sort_direction=='asc'), sortable_key, sch_data)
  end


  def sch_err_msg
   return 'You must specify a valid sortable data identifier.' 
  end


  def assemble_sort_key(*args)
    a = Array.new
    #a << request.env["REQUEST_PATH"] << args
    a << args
    a.flatten!.join('-')
  end

  
  def init_sortable_column_headers
    self.sortable_column_header_data = Hash.new
    true
  end


  def reset_sortable_columns
    session[:sortable_column_headers] = nil
  end


end