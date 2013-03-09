class MoviesPerson < ActiveRecord::Base
  belongs_to :movie
  belongs_to :person

  attr_accessible  :movie_id, :person_id, :profession, :profession_content
end
