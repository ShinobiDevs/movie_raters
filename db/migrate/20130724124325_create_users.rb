class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.column :email, :string
      t.column :name, :string
      t.timestamps
    end

    add_index :users, :email
  end
end
