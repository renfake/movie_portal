class CreateShootCompanies < ActiveRecord::Migration
  def change
    create_table :shoot_companies, :id => false do |t|
      t.integer       :movie_id,   :null => false
      t.integer       :company_id, :null => false
    end
  end
end
