class CreateApps < ActiveRecord::Migration[5.2]
  def change
    create_table :apps do |t|
      t.string :name
      t.text :description
      t.text :email
      t.string :help_link
      t.text :categories, array: true, default: []

      t.timestamps
    end
  end
end
