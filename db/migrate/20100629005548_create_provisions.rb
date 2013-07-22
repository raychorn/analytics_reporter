class CreateProvisions < ActiveRecord::Migration
  def self.up
    create_table :daily_provisions do |t|
      t.column :server_date,                      :date
      t.column :server_count,                :int
      t.column :server_handset,                   :string
      t.column :server_release,                   :string
      t.column :server_version,                   :string
      t.timestamps
    end
  end

  def self.down
    drop_table :provisions
  end
end
