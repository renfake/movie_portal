# coding: utf-8
class CreateProgramPlanTemplates < ActiveRecord::Migration
  def change
    create_table :program_plan_templates do |t|
      t.string :name, :null => false
      t.text   :desc

      t.string  :status, :null => false
      t.integer :time_bucket_num, :null => false

      ## 最小单位
      t.string  :unit,           :null => false, :default => 'DAY'
      ## 一行显示
      t.string  :line_unit,      :null => false, :default => 'WEEK'

      t.integer :day_column_num,      :null => false, :default => 7
      t.integer :day_row_num,         :null => false

      ## 周期
      t.string  :period,         :null => false, :default => 'WEEK'

      ## 频道
      t.integer :channel_id, :null => false

      t.integer :created_by, :null => false
      t.integer :updated_by, :null => false

      t.timestamps
    end
  end
end
