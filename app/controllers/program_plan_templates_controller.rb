# coding: utf-8
class ProgramPlanTemplatesController < ApplicationController

  def index
    @templates = ProgramPlanTemplate.all
  end

  def new
    @template = ProgramPlanTemplate.new
  end


  def create
    @template = ProgramPlanTemplate.new params[:program_plan_template]
    @template.unit = 'DAY'
    @template.line_unit = 'WEEK'
    @template.day_column_num = 7
    @template.status = 'ACTIVE'
    @template.day_row_num = (@template.period == 'MONTH'? 5 : 1)
    @template.created_by = current_user.id
    @template.updated_by = current_user.id
    if @template.save
      flash[:notice] = '新建编排模板成功'
      redirect_to program_plan_template_config_path(@template)
    else
      flash[:error] = @template.errors
      render :action => :new
    end
  end


  def item_config
    @template = ProgramPlanTemplate.find params[:id]
  end
end
