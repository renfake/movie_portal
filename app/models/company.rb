class Company < ActiveRecord::Base
  has_many :production_companies
  has_many :shoot_companies

  attr_accessible :name
end
