class CreateSpreeBoxes < ActiveRecord::Migration
  def change
    create_table :spree_boxes do |t|
      t.references :box_slot
      t.integer :slots

      t.decimal :height
      t.decimal :length
      t.decimal :width
      t.decimal :weight
      t.decimal :cost

      t.timestamps
    end
  end
end
