class CreateVttandroidsummaries < ActiveRecord::Migration
  def self.up
    create_table :vttandroidsummaries do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :vttandroidsummaries
  end
end
