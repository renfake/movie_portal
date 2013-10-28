class BroadcastUploadIssue < ActiveRecord::Base

  belongs_to :broadcast_upload

  attr_accessible :broadcast_upload_id, :row, :column, :field_name, :issue_type, :root_cause

  validates_numericality_of :row,    :greater_than_or_equal_to => 1, :allow_nil => true

  validates_presence_of     :column, :if => Proc.new {|issue| issue.row}
  validates_numericality_of :column, :greater_than_or_equal_to => 1, :allow_nil => true

  validates_presence_of     :field_name, :if => Proc.new {|issue| issue.row}

end
