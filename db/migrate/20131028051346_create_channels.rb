# coding: utf-8
class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name, :null => false
      t.timestamps
    end

    %w( CCTV6 CHC高清 ).each do |name|
      Channel.create! :name => name
    end
  end
end
