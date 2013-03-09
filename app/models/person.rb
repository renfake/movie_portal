class Person < ActiveRecord::Base
  has_and_belongs_to_many :professions
  has_many :movies_persons

  attr_accessible :name, :birthday, :bio
end
