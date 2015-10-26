class AddDurationToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :duration, :integer
  end
end
