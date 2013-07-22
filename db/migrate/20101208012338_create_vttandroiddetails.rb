class CreateVttandroiddetails < ActiveRecord::Migration
  def self.up
    create_table :vttandroiddetails do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :vttandroiddetails
  end
end
