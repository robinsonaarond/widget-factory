// This file is used by both the inline and expanded versions of the RISMedia widget.

const root = document.querySelector('.rismedia');
let focusedTabIndex = 0;

// Add click handlers to tabs
const tabs = Array.from(root.querySelectorAll('[role="tab"]'));
tabs.forEach(t => t.addEventListener('click', changeTabs));

// Add keydown handler to tab list
const tabList = document.querySelector('[role="tablist"]');
tabList.addEventListener('keydown', onTabListKeyDown);

// When View More News/Events/Reports is clicked, expand the widget and log an event
const viewMore = document.querySelectorAll('.rismedia .view-more');
if (viewMore.length) {
  viewMore.forEach(button => {
    button.addEventListener('click', () => {
      window.WidgetFactory.expand('rismedia');
      window.WidgetFactory.logEvent('widget_click_view_more', null, 'rismedia');
    });
  });
}

/** Change active tab (revealing the associated tab panel) when tab is clicked */
function changeTabs(e) {
  const tab = e.target.closest('[role="tab"]');
  const tabPanelId = tab.getAttribute('aria-controls');
  tabs.forEach(t => {
    t.setAttribute('aria-selected', tab === t);
  });
  root.querySelectorAll('[role="tabpanel"]').forEach(p => {
    let fromTo = ['flex', 'hidden'];
    if (p.id === tabPanelId) fromTo = fromTo.reverse();
    p.classList.replace(...fromTo);
  });
}

/** Handle arrow key navigation in tab list */
function onTabListKeyDown(e) {
  if (!['ArrowLeft', 'ArrowRight'].includes(e.key)) return;
  e.preventDefault();
  const tabCount = tabs.length;
  const direction = e.key === 'ArrowLeft' ? -1 : 1;
  focusedTabIndex = (focusedTabIndex + direction + tabCount) % tabCount;
  tabs[focusedTabIndex].focus();
}
