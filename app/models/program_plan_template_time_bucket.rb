class ProgramPlanTemplateTimeBucket < ActiveRecord::Base
  attr_accessible :time_bucket, :default_time, :program_plan_template_id

  belongs_to :program_plan_template
end
