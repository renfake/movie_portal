class ProgramPlanTemplateItem < ActiveRecord::Base
  attr_accessible :program_plan_template_id, :day_row, :day_column, :time_bulk, :status

  belongs_to :program_plan_template
end
