class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.integer :ff_id
      t.string :first_name
      t.string :last_name
      t.string :web_name
      t.text :data

      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
