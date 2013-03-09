class CreateMoviesIssues < ActiveRecord::Migration
  def change
    create_table :movies_issues, :id => false do |t|
      t.integer       :movie_id,      :null => false
      t.integer       :issue_id,     :null => false
    end
  end
end
