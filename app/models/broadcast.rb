class Broadcast < ActiveRecord::Base

  belongs_to :movie

  attr_accessible :week, :date, :start_time, :movie_id, :audience_rating, :audience_share, :audience_number, :time_bucket, :premiere, :created_by, :updated_by
end
