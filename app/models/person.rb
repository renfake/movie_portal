class Person < ActiveRecord::Base
  has_and_belongs_to_many :professions

  attr_accessible :name, :birthday, :bio
end
