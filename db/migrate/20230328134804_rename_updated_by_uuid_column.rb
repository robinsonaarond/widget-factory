class RenameUpdatedByUuidColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :widgets, :updated_by_uuid, :updated_by
  end
end
