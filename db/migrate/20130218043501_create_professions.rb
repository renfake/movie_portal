# coding: utf-8
class CreateProfessions < ActiveRecord::Migration
  def change
    create_table :professions do |t|
      t.string        :name,  :null => false
      t.timestamps
    end

    %w( 演员 导演 制片人 编剧 ).each do |name|
      Profession.create! :name => name
    end
  end
end
