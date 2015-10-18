class RedmineApplicationController < ApplicationController
  unloadable
  before_filter :find_project

  def index
    respond_to do |format|
      format.html{
        if User.current.admin
          @rapp = RedmineApplication.where(project_id: @project.id).order('id DESC')
        else
          @rapp = RedmineApplication.where(project_id: @project.id).where(user_id: User.current.id).order('id DESC')
          @roles = Role.sorted.all.map{|r| [r.name, r.id]}
        end
      }
      format.js{
        if User.current.admin
          @ra = RedmineApplication.find(params[:rapp_id])
          @ra.status = params[:status]
          @ra.save
        end
      }
    end
  end

  def suggest
    rapp = RedmineApplication.new(project_id: @project.id)
    rapp.role_id = params[:role_id]
    rapp.comment = params[:comment]
    rapp.user_id = User.current.id
    rapp.save
    flash[:notice] = "Saved Successfully"
    redirect_to :back
  end

  private

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find(params[:project_id])
  end

end
