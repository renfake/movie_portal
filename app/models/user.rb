# coding: utf-8
class User < ActiveRecord::Base
  simple_roles
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :registerable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :role
  # attr_accessible :title, :body

  validates_inclusion_of :role, :in => SimpleRoles.config.valid_roles, :message => "must be #{SimpleRoles.config.valid_roles.join(',')}"



  #分数
  has_many        :scores,        :class_name => 'UsersMoviesScore'
end
