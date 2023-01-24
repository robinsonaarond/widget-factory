Widget.create([
  {
    component: "widget_panel",
    partner: "",
    name: "My Widgets",
    description: "",
    logo_link_url: "",
    status: "ready",
    activation_date: Time.zone.now,
    internal: true
  },
  {
    component: "hurdlr",
    partner: "Hurdlr",
    name: "Profit + Loss",
    description: "Get a quick glance of your profit and loss statement.",
    logo_link_url: "https://prod-integration.hurdlr.com/saml/assertion/stellar",
    status: "ready",
    activation_date: Time.zone.now,
    internal: false
  },
  {
    component: "list_trac",
    partner: "ListTrac",
    name: "Online Activity",
    description: "View and track online activity for your listings.",
    logo_link_url: "https://stellar.sso.listtrac.com/Account/SingleSignOn",
    status: "ready",
    activation_date: Time.zone.now,
    internal: false
  }
])
