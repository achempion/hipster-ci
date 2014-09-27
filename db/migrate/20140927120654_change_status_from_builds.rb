class ChangeStatusFromBuilds < ActiveRecord::Migration
  def change
    change_column :builds, :status, :integer, default: 0
  end
end
