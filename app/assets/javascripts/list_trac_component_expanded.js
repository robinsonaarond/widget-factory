function initListingTable(listingsJson) {
  const table = document.querySelector('mx-table');
  table.rows = JSON.parse(listingsJson);
  table.columns = [
    { heading: 'Address', property: 'Address', sortable: true },
    { heading: 'Views', property: 'ViewCount', sortable: true },
    { heading: 'Leads', property: 'InquiryCount', sortable: true },
    { isActionColumn: true }, // Design has a blank column here
  ];
}
