class RemoveInteralFromWidgets < ActiveRecord::Migration[7.0]
  def change
    # This was only used to hide the widget panel from the widget list, which really did not need
    # to be added to the database in the first place.  This column would also add confusion since
    # we will soon have internal widgets (e.g. hurdlr, list_trac, tips) vs. external widgets (in an iframe).
    remove_column :widgets, :internal
  end
end
