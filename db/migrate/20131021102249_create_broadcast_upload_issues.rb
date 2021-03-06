# coding: utf-8
class CreateBroadcastUploadIssues < ActiveRecord::Migration
  def change
    create_table :broadcast_upload_issues do |t|
      t.integer :broadcast_upload_id, :null => false

      ## 行号
      t.integer :row
      t.integer :column

      t.string :field_name, :default => ''

      ## 问题类型： 错误(ERROR)、警告(WARNNING)
      t.string  :issue_type, :null => false
      ## 具体问题原因  JSON format
      t.text    :root_cause

      t.timestamps
    end
  end
end
