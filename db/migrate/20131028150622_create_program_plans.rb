class CreateProgramPlans < ActiveRecord::Migration
  def change
    create_table :program_plans do |t|

      t.timestamps
    end
  end
end
