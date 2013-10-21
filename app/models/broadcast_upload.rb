class BroadcastUpload < ActiveRecord::Base

  has_many :broadcast_upload_issues
  has_many :broadcasts

  # attr_accessible :title, :body
end
