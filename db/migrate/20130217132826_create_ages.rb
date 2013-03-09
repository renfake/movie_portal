# coding: utf-8
class CreateAges < ActiveRecord::Migration
  def change
    create_table :ages do |t|
      t.string        :content, :null => false
      t.timestamps
    end

    %w( 古代<1840年之前> 近代<1840-1919> 现代<1919-1949> 当代<1949-1979> 当下 ).each do |content|
      Age.create! :content => content
    end
  end
end
