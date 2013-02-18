class Movie < ActiveRecord::Base
  belongs_to :category
  belongs_to :age
  has_and_belongs_to_many :genres

  attr_accessible :name, :country, :runtime
end
