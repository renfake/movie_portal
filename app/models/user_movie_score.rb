class UserMovieScore < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie
  belongs_to :score
  attr_accessible :user_id, :movie_id, :score_id, :mark
end
