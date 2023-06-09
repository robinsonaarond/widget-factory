class UpdateListTracLogo < ActiveRecord::Migration[7.0]
  # Reattach ListTrac logo due to resizing
  def change
    Widget.find_by(component: "list_trac").logo.attach(io: File.open(Rails.root.join("app", "assets", "images", "list_trac", "logo.png")), filename: "logo.png")
  end
end
