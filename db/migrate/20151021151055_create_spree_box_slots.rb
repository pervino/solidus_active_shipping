class CreateSpreeBoxSlots < ActiveRecord::Migration
  def change
    create_table :spree_box_slots do |t|
      t.string :label
      t.boolean :default, default: false

      t.timestamps
    end

    add_column :spree_products, :box_slot_id, :integer
    add_index :spree_products, :box_slot_id
  end
end
