class AddMessageToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :message, :text
  end
end
