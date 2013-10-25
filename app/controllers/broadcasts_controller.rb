# coding: utf-8
require "roo"
class BroadcastsController < ApplicationController

  def index
    @broadcasts = Broadcast.all
  end


  def upload

  end




end
