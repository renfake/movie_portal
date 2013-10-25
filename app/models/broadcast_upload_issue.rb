class BroadcastUploadIssue < ActiveRecord::Base

  belongs_to :broadcast_upload

  attr_accessible :broadcast_upload_id, :row, :issue_type, :root_cause
end
