class Age < ActiveRecord::Base
  has_many :movies

  attr_accessible :name

  validates_presence_of :name
end
