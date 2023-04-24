class AddRemovedToUserWidgets < ActiveRecord::Migration[7.0]
  def change
    add_column :user_widgets, :removed, :boolean, default: false
  end
end
