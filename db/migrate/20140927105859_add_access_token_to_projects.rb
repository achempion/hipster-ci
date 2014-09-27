class AddAccessTokenToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :access_token, :string
  end
end
