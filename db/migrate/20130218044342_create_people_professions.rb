class CreatePeopleProfessions < ActiveRecord::Migration
  def change
    create_table :people_professions, :id => false do |t|
      t.integer :person_id,     :null => false
      t.integer :profession_id, :null => false
    end
  end
end
