class CreateProgramPlanTemplateItems < ActiveRecord::Migration
  def change
    create_table :program_plan_template_items do |t|
      t.integer :program_plan_template_id, :null => false

      t.integer :day_row,      :null => false
      t.integer :time_bulk,    :null => false
      t.integer :day_column,   :null => false

      t.string  :status,       :null => false
      t.string  :note

      t.timestamps
    end
  end
end
