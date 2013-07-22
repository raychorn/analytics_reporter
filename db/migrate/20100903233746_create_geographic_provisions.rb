class CreateGeographicProvisions < ActiveRecord::Migration
  def self.up
    create_table :geographic_provisions do |t|

      t.column :service_date,        :date
      t.column :service_hour,        :int
      t.column :handset_count,       :int
      t.column :area_code,           :int
      t.column :handset,             :string
      t.column :server_version,      :string
      t.column :sw_release,          :string
      t.timestamps
    end
  end

  def self.down
    drop_table :geographic_provisions
  end
end
