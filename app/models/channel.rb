class Channel < ActiveRecord::Base
  attr_accessible :name

  has_many :program_plan_templates

end
