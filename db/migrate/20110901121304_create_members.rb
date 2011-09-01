class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.integer :team_id
      t.integer :player_id
      t.integer :price_paid
      t.integer :start_week
      t.integer :end_week

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
