# coding: utf-8
class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors do |t|
      t.string        :name, :null => false
      t.timestamps
    end

    %w( '彩色'  '黑白').each do |color|
      Color.create! :name=>color
    end
  end
end
