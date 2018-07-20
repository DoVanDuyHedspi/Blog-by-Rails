class RemoveRemembweFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :remembwe, :string
  end
end
