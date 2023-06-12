class AddRismediaWidget < ActiveRecord::Migration[7.0]
  def change
    w = Widget.create({
      component: "rismedia",
      partner: "RISMedia",
      name: "Latest from RISMedia",
      description: "Stay up-to-date on the latest real estate news from RISMedia.",
      logo_link_url: "https://www.rismedia.com/StellarMLS-auth/?news_id=0",
      status: "ready",
      activation_date: Time.zone.now
    })
    w.logo.attach(io: File.open(Rails.root.join("app", "assets", "images", "rismedia", "logo.png")), filename: "logo.png")
  end
end
