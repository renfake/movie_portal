class ProgramPlanTemplate < ActiveRecord::Base
  attr_accessible :name, :desc, :status, :time_bucket_num, :day_column_num, :day_row_num, :serve_for, :channel_id, :created_by, :updated_by

  belongs_to :creater, :class_name => 'User', :foreign_key => 'created_by'
  belongs_to :updater, :class_name => 'User', :foreign_key => 'updated_by'

  belongs_to :channel

  has_many :program_plan_template_items
end
