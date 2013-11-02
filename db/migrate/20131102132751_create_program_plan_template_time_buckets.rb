class CreateProgramPlanTemplateTimeBuckets < ActiveRecord::Migration
  def change
    create_table :program_plan_template_time_buckets do |t|
      t.integer :program_plan_template_id, :null => false

      t.integer :time_bucket, :null => false
      t.time    :default_time

      t.timestamps
    end
  end
end
