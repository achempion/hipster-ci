class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.integer :project_id
      t.integer :status
      t.text :result

      t.timestamps
    end
  end
end