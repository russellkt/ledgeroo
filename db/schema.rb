# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081005232854) do

  create_table "account_groups", :force => true do |t|
    t.string  "name"
    t.boolean "is_debit",  :default => false
    t.boolean "is_credit", :default => false
  end

  create_table "account_types", :force => true do |t|
    t.string  "name"
    t.integer "account_group_id"
  end

  create_table "accounting_entries", :force => true do |t|
    t.integer  "accounting_transaction_id"
    t.integer  "account_id"
    t.decimal  "debit",                     :precision => 10, :scale => 2
    t.decimal  "credit",                    :precision => 10, :scale => 2
    t.string   "memo"
    t.boolean  "has_cleared",                                              :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "accountable_id"
    t.string   "accountable_type"
    t.integer  "statement_id"
  end

  add_index "accounting_entries", ["accountable_id"], :name => "index_accounting_entries_on_accountable_id"
  add_index "accounting_entries", ["accounting_transaction_id"], :name => "index_accounting_entries_on_accounting_transaction_id"
  add_index "accounting_entries", ["account_id"], :name => "index_accounting_entries_on_account_id"

  create_table "accounting_transactions", :force => true do |t|
    t.string   "name"
    t.integer  "document_id"
    t.integer  "document_number"
    t.string   "memo"
    t.date     "recorded_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "transaction_type"
    t.boolean  "is_void",                                         :default => false
    t.integer  "department_id"
    t.integer  "class_id"
    t.integer  "location_id"
    t.string   "accountable_type"
    t.integer  "accountable_id"
    t.integer  "reversal_id"
    t.integer  "batch_id"
    t.decimal  "total",            :precision => 10, :scale => 2
  end

  add_index "accounting_transactions", ["accountable_id"], :name => "index_accounting_transactions_on_accountable_id"
  add_index "accounting_transactions", ["batch_id"], :name => "index_accounting_transactions_on_batch_id"
  add_index "accounting_transactions", ["transaction_type"], :name => "index_accounting_transactions_on_transaction_type"

  create_table "accounts", :force => true do |t|
    t.text     "name"
    t.text     "description"
    t.integer  "account_type_id"
    t.text     "number"
    t.text     "bank_number"
    t.boolean  "is_inactive",     :default => false
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "batch_imports", :force => true do |t|
    t.integer  "batch_id"
    t.integer  "accountable_id"
    t.string   "accountable_type"
    t.string   "document_number"
    t.date     "recorded_on"
    t.string   "payee"
    t.string   "account_number"
    t.decimal  "amount",           :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "batches", :force => true do |t|
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "finalized",  :default => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statements", :force => true do |t|
    t.integer "account_id"
    t.date    "started_on"
    t.date    "ended_on"
    t.decimal "beginning_balance", :precision => 10, :scale => 2
    t.decimal "ending_balance",    :precision => 10, :scale => 2
    t.boolean "is_closed"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                   :default => "passive"
    t.datetime "deleted_at"
  end

end
