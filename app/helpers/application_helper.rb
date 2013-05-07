#coding: utf-8
module ApplicationHelper
  CURRENT_NAV_CLASS = 'selected'

  def main_nav_link(link_text, link_path, icon_text, *controllers )
    recognized = Rails.application.routes.recognize_path(link_path)
    controllers << recognized[:controller]

    class_name = CURRENT_NAV_CLASS if (controller? *controllers)

    content_tag(:li) do
      link_to link_path, :class => class_name do
        icon = content_tag(:div, '', 'data-icon' => icon_text, 'aria-hidden' => 'true', :class => 'fs1')

        icon + link_text
      end
    end
  end

  def sub_nav_link(link_text, link_path, current, *class_name)
    class_name <<  CURRENT_NAV_CLASS if class_name.include? current
    content_tag(:li) do
      link_to link_text, link_path, :class => class_name.join(' ')
    end
  end

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end
end
