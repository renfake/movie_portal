# coding: utf-8
class CreateFormats < ActiveRecord::Migration
  def change
    create_table :formats do |t|
      t.string      :name, :null => false
      t.timestamps
    end

    %w( 标清 高清 胶片 ).each do |format|
      Format.create! :name => format
    end
  end
end
