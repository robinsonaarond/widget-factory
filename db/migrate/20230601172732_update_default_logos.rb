class UpdateDefaultLogos < ActiveRecord::Migration[7.0]
  # The default logos were resized for consistency, so we need to re-attach them
  def change
    ["hurdlr", "list_trac", "tips"].each do |component|
      Widget.find_by(component: component).logo.attach(io: File.open(Rails.root.join("app", "assets", "images", component, "logo.png")), filename: "logo.png")
    end
  end
end
