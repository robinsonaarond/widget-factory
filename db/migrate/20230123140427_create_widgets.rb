class CreateWidgets < ActiveRecord::Migration[7.0]
  def change
    create_table :widgets do |t|
      t.string :component
      t.string :partner
      t.string :name
      t.string :description
      t.string :logo_link_url
      t.string :status
      t.datetime :activation_date
      t.boolean :internal
      t.string :updated_by_uuid

      t.timestamps
    end
  end
end
