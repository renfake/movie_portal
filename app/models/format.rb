class Format < ActiveRecord::Base
  has_many :movies
  attr_accessible :name
end
