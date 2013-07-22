class CreateSwaps < ActiveRecord::Migration
  def self.up
    create_table :daily_swaps do |t|
      t.column :server_date,               :date
      t.column :cumm_count,                :int
      t.column :inc_count,                 :int
      t.column :from_handset,              :string
      t.column :from_release,              :string
      t.column :from_version,              :string
      t.column :to_handset,                :string
      t.column :to_release,                :string
      t.column :to_version,                :string
      t.timestamps
    end
  end

  def self.down
    drop_table :swaps
  end
end
