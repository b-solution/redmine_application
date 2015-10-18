Redmine::Plugin.register :redmine_application do
  name 'Redmine Application plugin'
  author 'BILEL KEDIDI'
  description 'This is a plugin for submit application to belong on that project'
  version '0.0.1'
  url 'http://github.com/bilel-kedidi'
  author_url 'http://github.com/bilel-kedidi'

  settings :default => {
               'cp'    => 'Project stage',
               'value' => 'Initiative'
           }#, :partial => 'redmine_application/setting'


  permission :view_application, :redmine_application => :index, :public=> true
  menu :project_menu, :redmine_application,
       { :controller => 'redmine_application', :action => 'index' },
       :if => Proc.new {
         User.current.logged?
       },
       :caption => 'Application', :after => :files, :param => :project_id
end

Rails.application.config.to_prepare do
  module Redmine
    module MenuManager
      module MenuHelper
        def self.included(base)
          base.class_eval do
            alias_method_chain :render_menu, :new
          end
        end
        def render_menu_with_new(menu, project=nil)
          links = []
          value = ""
          settings = Setting.send "plugin_redmine_application"
          if project
            begin
              value = project.custom_field_values.select{|cfv| cfv.custom_field.name == settings['cp']}.first.value
            rescue
              value = ""
            end
          end
          menu_items_for(menu, project) do |node|
            if node.children.present? || !node.child_menus.nil?
              links << render_menu_node(node, project)
            else
              if !node.url.is_a?(Hash) or (node.url.stringify_keys['controller'] == 'redmine_application' and value == settings['value']) or (node.url.stringify_keys['controller'] != 'redmine_application')
                links <<  render_menu_node(node, project)
              end
            end
          end
          links.empty? ? nil : content_tag('ul', links.join("\n").html_safe)
        end
      end
    end
  end
end

