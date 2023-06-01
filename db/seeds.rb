Widget.create([
  {
    component: "hurdlr",
    partner: "Hurdlr",
    name: "Profit + Loss",
    description: "Get a quick glance of your profit and loss statement.",
    logo_link_url: "https://prod-integration.hurdlr.com/saml/assertion/stellar",
    status: "ready",
    activation_date: Time.zone.now
  },
  {
    component: "list_trac",
    partner: "ListTrac",
    name: "Online Activity",
    description: "View and track online activity for your listings.",
    logo_link_url: "https://stellar.sso.listtrac.com/Account/SingleSignOn",
    status: "ready",
    activation_date: Time.zone.now
  },
  {
    component: "tips",
    partner: "Stellar",
    name: "Tip of the Week",
    description: "Stay ahead of the game with our weekly real estate tip! Stay up-to-date on industry trends to grow your business in just a few minutes a week.",
    logo_link_url: "",
    status: "ready",
    activation_date: Time.zone.now
  }
])

["hurdlr", "list_trac", "tips"].each do |component|
  Widget.find_by(component: component).logo.attach(io: File.open(Rails.root.join("app", "assets", "images", component, "logo.png")), filename: "logo.png")
end
