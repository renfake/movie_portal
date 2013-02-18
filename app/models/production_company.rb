class ProductionCompany < ActiveRecord::Base
  belongs_to :movie
  belongs_to :company

  attr_accessible :movie_id, :company_id
end
