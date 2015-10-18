class CreateRedmineApplications < ActiveRecord::Migration
  def change
    create_table :redmine_applications do |t|
      t.integer :project_id
      t.integer :user_id
      t.integer :role_id
      t.string :comment
      t.string :status
      t.timestamps
    end
  end
end
