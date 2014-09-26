class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :path
    end
  end
end
