class CreateBlacklists < ActiveRecord::Migration[5.2]
  def change
    create_table :blacklists do |t|
      t.string :jti
      t.timestamps
    end
  end
end
