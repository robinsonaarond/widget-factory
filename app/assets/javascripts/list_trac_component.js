// When View More is clicked, expand the widget and log an event
const viewMore = document.querySelector('.list_trac .view-more');
if (viewMore) {
  viewMore.addEventListener('click', () => {
    window.WidgetFactory.expand('list_trac');
    window.WidgetFactory.logEvent('widget_click_view_more', null, 'list_trac');
  });
}
