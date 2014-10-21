class AddNotificationsToProject < ActiveRecord::Migration
  def change
    add_column :projects, :notifications, :integer
  end
end
