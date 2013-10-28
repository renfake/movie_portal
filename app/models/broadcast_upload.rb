class BroadcastUpload < ActiveRecord::Base

  has_many :broadcasts

  has_many :issue_records,   :class_name =>  'BroadcastUploadIssue', :foreign_key => 'broadcast_upload_id', :order => 'row'
  has_many :error_records ,  :class_name => 'BroadcastUploadIssue', :foreign_key => 'broadcast_upload_id',
           :conditions => {:issue_type => 'ERROR'}, :order => 'row'
  has_many :warning_records, :class_name => 'BroadcastUploadIssue', :foreign_key => 'broadcast_upload_id',
           :conditions => { :issue_type => 'WARNING'}, :order => 'row'


  #has_many :row_issue_records,   :class_name =>  'BroadcastUploadIssue', :foreign_key => 'broadcast_upload_id',
  #         :conditions => 'row is NOT NULL', :order => 'row'
  #has_many :row_error_records ,  :class_name => 'BroadcastUploadIssue', :foreign_key => 'broadcast_upload_id',
  #         :conditions => ['issue_type = :issue_type AND row is not NULL', {:issue_type => 'ERROR'}], :order => 'row'
  #has_many :row_warning_records, :class_name => 'BroadcastUploadIssue', :foreign_key => 'broadcast_upload_id',
  #         :conditions => ['issue_type = :issue_type AND row is not NULL', {:issue_type => 'WARNING'}], :order => 'row'


  belongs_to :user, :foreign_key => 'created_by'


  attr_accessible :file_name, :note, :skip_the_first_line, :go_with_warning, :count, :min_time, :max_time, :status, :created_by


  def can_import?

  end

  def failed?
    self.status == 'FAIL'
  end

  def records_by_row(kind = :all)
    records = issue_records
    records = error_records if kind == :error
    records = warning_records if kind == :warning

    result = Hash.new
    result[:global] = []
    result[:rows]   = []

    records.each do |record|
      if record.row.nil?
        result[:global] << record
        continue
      end


      result[record.row] ||= Hash.new
      row = result[record.row]
      result[:rows] << row  unless result[:rows].include?(row)

      row[:row_number] ||= record.row
      row[record.column] = record
      row[record.field_name] = record
    end

    result
  end

end
