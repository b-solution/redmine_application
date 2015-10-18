class RedmineApplication < ActiveRecord::Base
  unloadable

  belongs_to :project
  belongs_to :user
  belongs_to :role

end
