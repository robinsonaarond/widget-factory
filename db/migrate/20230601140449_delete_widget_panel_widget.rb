class DeleteWidgetPanelWidget < ActiveRecord::Migration[7.0]
  def change
    # There was no need to have a widget record for the widget panel (this has been removed from seeds.rb)
    Widget.where(component: "widget_panel").delete_all
  end
end
