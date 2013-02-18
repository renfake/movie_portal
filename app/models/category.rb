class Category < ActiveRecord::Base
  has_many :movies

  attr_accessible         :name
  validates_presence_of   :name
  validates_uniqueness_of :name
end
