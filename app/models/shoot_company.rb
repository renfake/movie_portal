class ShootCompany < ActiveRecord::Base
  belongs_to :company
  belongs_to :movie

  attr_accessible :movie_id, :company_id
end
