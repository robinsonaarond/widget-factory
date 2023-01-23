class CreateUserWidgets < ActiveRecord::Migration[7.0]
  def change
    create_table :user_widgets do |t|
      t.string :user_uuid
      t.references :widget, null: false, foreign_key: true
      t.integer :row_order

      t.timestamps
    end
  end
end
