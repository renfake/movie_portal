class Age < ActiveRecord::Base
  has_many :movies

  attr_accessible :content
  validates_presence_of :content
end
