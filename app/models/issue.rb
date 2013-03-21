class Issue < ActiveRecord::Base

  has_and_belongs_to_many :movies, :join_table => 'movies_issues'

  attr_accessible :name, :desc
end
