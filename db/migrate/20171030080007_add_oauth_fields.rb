class AddOauthFields < ActiveRecord::Migration[5.0]
  def change
    add_column :works, :writer, :integer
  end
end
