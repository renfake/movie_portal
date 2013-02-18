class Profession < ActiveRecord::Base
  has_and_belongs_to_many :persons

  attr_accessible         :name
  validates_presence_of   :name
  validates_uniqueness_of :name
end
