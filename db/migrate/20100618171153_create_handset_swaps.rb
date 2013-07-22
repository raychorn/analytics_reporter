class CreateHandsetSwaps < ActiveRecord::Migration
  def self.up
    create_table :handset_swaps do |t|
	  t.column :server_date,               :date
      t.column :hand_set_from,             :string
      t.column :hand_set_sw_rel_from,      :string
      t.column :hand_set_firmware_from,    :string
      t.column :hand_set_to,               :string
      t.column :hand_set_sw_rel_to,        :string
      t.column :hand_set_firmware_to,      :string
      t.column :server_count,              :int
    end
  end

  def self.down
    drop_table :handset_swaps
  end
end
