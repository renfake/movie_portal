class CreateMoviesCompanies < ActiveRecord::Migration
  def change
    create_table :movies_companies, :id => false do |t|
      t.integer :movie_id,        :null => false
      t.integer :company_id,      :null => false
      t.integer :duty,            :null => false
    end
  end
end
