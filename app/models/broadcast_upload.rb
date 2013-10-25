class BroadcastUpload < ActiveRecord::Base

  has_many :broadcast_upload_issues
  has_many :broadcasts

  belongs_to :user, :foreign_key => 'created_by'


  attr_accessible :file_name, :note, :skip_the_first_line, :go_with_warning, :count, :min_time, :max_time, :status, :created_by


  def can_import?

  end
end
