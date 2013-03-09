# coding: utf-8
class CreateProfessions < ActiveRecord::Migration
  def change
    create_table :professions do |t|
      t.string        :name,  :null => false
      t.timestamps
    end

    %w( 监制 导演 制片人 编剧 摄影 美术 副导演 剪辑 主要演员 演员 ).each do |name|
      Profession.create! :name => name
    end
  end
end
