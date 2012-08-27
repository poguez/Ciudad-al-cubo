class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :token, :limit => 255
      t.string :secret, :limit => 255
      t.string :uid
      t.timestamps
    end
  end
end
