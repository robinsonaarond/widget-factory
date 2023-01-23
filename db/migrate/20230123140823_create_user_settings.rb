class CreateUserSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :user_settings do |t|
      t.string :user_uuid
      t.references :widget, null: false, foreign_key: true
      t.string :name
      t.text :value

      t.timestamps
    end
  end
end
