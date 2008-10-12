# == Schema Information
# Schema version: 13
#
# Table name: roles
#
#  id                :integer         not null, primary key
#  name              :string(40)      
#  authorizable_type :string(40)      
#  authorizable_id   :integer         
#  created_at        :datetime        
#  updated_at        :datetime        
#

# Defines named roles for users that may be applied to
# objects in a polymorphic fashion. For example, you could create a role
# "moderator" for an instance of a model (i.e., an object), a model class,
# or without any specification at all.
class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :authorizable, :polymorphic => true
end
