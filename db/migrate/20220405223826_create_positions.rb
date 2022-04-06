class CreatePositions < ActiveRecord::Migration[7.0]
  def change
    create_table :positions do |t|
      t.integer :point_x
      t.integer :point_y
      t.string :direction
      t.integer :final

      t.timestamps
    end
  end
end
