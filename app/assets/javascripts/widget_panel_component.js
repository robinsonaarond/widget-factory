const root = document.querySelector('.widget_panel');

document.addEventListener('DOMContentLoaded', () => {
  logEvent('widget_dashboard_load', { timeMs: performance.now() });
});

// Notify parent window of height changes
const resizeObserver = new ResizeObserver(entries => {
  const height = entries[0].contentRect.height;
  window.parent.postMessage(
    { type: 'RESIZE', payload: { component: 'widget_panel', height } },
    '*'
  );
});
resizeObserver.observe(root);

const addButton = root.querySelector('mx-button');
if (addButton) {
  addButton.addEventListener('click', () => {
    const expandedUrl = root.dataset.expandedUrl;
    const url = window.location.origin + expandedUrl + window.location.search;
    setLoading(true);
    window.parent.postMessage({ type: 'EXPAND', payload: { url } }, '*');
  });
}

window.addEventListener('message', e => {
  const { type, payload } = e.data;
  if (type === 'REMOVE') removeWidget(payload.component);
  else if (e.data.type === 'LOG_EVENT') {
    const { eventType, eventData, component } = e.data.payload;
    logEvent(eventType, eventData, component);
  } else if (e.data.type === 'SET_LOADING') {
    const { isLoading, component } = e.data.payload;
    if (component === 'widget_panel') setLoading(isLoading);
  }
});

function setLoading(isLoading) {
  const loading = root.querySelector('.panel-loading');
  if (isLoading) {
    loading.classList.replace('hidden', 'flex');
  } else {
    loading.classList.replace('flex', 'hidden');
  }
}

function removeWidget(component) {
  const widget = root.querySelector(`[data-widget-component="${component}"]`);
  destroyUserWidget(widget.dataset.widgetId);
  logEvent('widget_remove_via_menu', null, component);
  widget.remove();
  if (!root.querySelector('li')) {
    root.querySelector('.empty-state').classList.remove('hidden');
  } else {
    resetWidgetOrderAttributes();
  }
}

function logEvent(eventType, eventData, component = 'widget_panel') {
  _fetch(`/api/events/?session_id=${window.WidgetFactory.SESSION_ID}`, {
    method: 'POST',
    body: JSON.stringify({
      event_type: eventType,
      event_data: eventData,
      component,
    }),
  });
}

// Drag sorting

const KEYBOARD_DRAG_CLASSES = ['transform', '-translate-y-10'];
const MOUSE_DRAG_CLASSES = ['z-50', 'pointer-events-none'];
const dragHandleHtml = name => `
  <div class="touch-drag-handle mr-10">
    <button
      class="keyboard-drag-button flex pointer-events-none"
      aria-describedby="reorder-help"
      aria-label="Reorder ${name}"
    >
      <span class="icon icon-drag"></span>
    </button>
  </div>`;
let draggedWidget; // Widget being dragged
let overWidget; // Widget being dragged over
let offsetX, offsetY; // Pointer offset from top left of widget when dragging started

// Add drag handles and event listeners
const widgets = root.querySelectorAll('li');
widgets.forEach((widget, i) => {
  const header = widget.querySelector('header');
  header.insertAdjacentHTML(
    'afterbegin',
    dragHandleHtml(widget.dataset.widgetName)
  );
  header.classList.add('cursor-move');
  widget.addEventListener('mousedown', onPointerDown);
  widget.addEventListener('touchstart', onPointerDown);
  widget.addEventListener('mouseover', onMouseOver);
  const keyboardDragButton = widget.querySelector('.keyboard-drag-button');
  keyboardDragButton.addEventListener('keydown', onKeyDown);
});
resetWidgetOrderAttributes();

function onPointerDown(e) {
  let handle =
    e.type === 'mousedown'
      ? e.target.closest('header')
      : e.target.closest('.touch-drag-handle');
  if (!handle) return; // Do not drag unless dragging by the drag handle
  e.preventDefault();
  draggedWidget = e.target.closest('li');
  draggedWidget.classList.add(...MOUSE_DRAG_CLASSES);
  const { clientX, clientY } = getPointer(e);
  offsetX = clientX - draggedWidget.offsetLeft;
  offsetY = clientY - draggedWidget.offsetTop;
  window.addEventListener('mousemove', onPointerMove);
  window.addEventListener('touchmove', onPointerMove);
  window.addEventListener('mouseup', onPointerUp);
  window.addEventListener('touchend', onPointerUp);
}

function onMouseOver(e) {
  if (!draggedWidget || e.buttons === 0) return; // Only drag if mouse is down
  e.preventDefault();
  visuallyReorder(e.target.closest('li'));
}

function onPointerMove(e) {
  if (!draggedWidget) return;
  const rect = draggedWidget.getBoundingClientRect();
  const { clientX, clientY } = getPointer(e);
  const x = clientX - draggedWidget.offsetLeft - offsetX;
  const y = clientY - draggedWidget.offsetTop - offsetY;
  draggedWidget.style.transform = `translate(${x}px, ${y}px)`;
  if (e.type === 'touchmove') {
    // Since there is no mouseover event for touch, we need to check for element using elementFromPoint
    const target = document.elementFromPoint(clientX, clientY);
    if (!target) return;
    const targetWidget = target.closest('li');
    if (targetWidget) visuallyReorder(targetWidget);
  }
}

function onPointerUp(e) {
  if (!draggedWidget) return;
  draggedWidget.style.transform = '';
  draggedWidget.classList.remove(...MOUSE_DRAG_CLASSES);
  reorderWidgetElements();
  draggedWidget = null;
  window.removeEventListener('mousemove', onPointerMove);
  window.removeEventListener('touchmove', onPointerMove);
  window.addEventListener('mouseup', onPointerUp);
  window.addEventListener('touchend', onPointerUp);
  // TODO: Persist new order
}

function onKeyDown(e) {
  if (['Enter', ' '].includes(e.key)) {
    if (draggedWidget) return keyboardDrop(e);
    return keyboardPickUp(e);
  }
  if (!draggedWidget) return;
  if (['Tab', 'Escape'].includes(e.key)) return keyboardCancel();
  if (['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight'].includes(e.key)) {
    return keyboardMove(e);
  }
}

function keyboardPickUp(e) {
  e.preventDefault();
  draggedWidget = e.target.closest('li');
  document.activeElement.setAttribute('aria-pressed', 'true');
  draggedWidget.classList.add(...KEYBOARD_DRAG_CLASSES);
}

function keyboardMove(e) {
  e.preventDefault();
  const order = getOrder(draggedWidget);
  const widgets = Array.from(root.querySelectorAll('li')).sort(
    (a, b) => getOrder(a) - getOrder(b)
  );
  if (['ArrowUp', 'ArrowLeft'].includes(e.key) && order !== 0) {
    visuallyReorder(widgets[order - 1]);
  } else if (
    ['ArrowDown', 'ArrowRight'].includes(e.key) &&
    order !== widgets.length - 1
  ) {
    visuallyReorder(widgets[order + 1]);
  }
}

function keyboardCancel() {
  overWidget = null;
  keyboardDrop();
}

function keyboardDrop(e) {
  if (!draggedWidget) return;
  if (e) e.preventDefault();
  draggedWidget.classList.remove(...KEYBOARD_DRAG_CLASSES);
  reorderWidgetElements();
  document.activeElement.setAttribute('aria-pressed', 'false');
  draggedWidget = null;
}

function visuallyReorder(newOverWidget) {
  // Safari is slow to update the DOM, so while dragging, we only update the CSS order attribute.
  // This also allows us to cancel keyboard dragging by simply reverting the order attributes.
  overWidget = newOverWidget;
  root.querySelectorAll('li').forEach(widget => {
    if (widget === draggedWidget) widget.dataset.order = getOrder(overWidget);
    else if (getOrder(overWidget) > getOrder(draggedWidget)) {
      if (
        getOrder(widget) > getOrder(draggedWidget) &&
        getOrder(widget) <= getOrder(overWidget)
      ) {
        widget.dataset.order = getOrder(widget) - 1;
      }
    } else {
      if (
        getOrder(widget) < getOrder(draggedWidget) &&
        getOrder(widget) >= getOrder(overWidget)
      ) {
        widget.dataset.order = getOrder(widget) + 1;
      }
    }
  });
  // Apply the new order attributes using the dataset values set above
  root.querySelectorAll('li').forEach(widget => {
    widget.style.order = widget.dataset.order;
    widget.removeAttribute('data-order');
  });
}

function reorderWidgetElements() {
  const focused = document.activeElement;
  if (overWidget && getOrder(draggedWidget) !== getIndex(draggedWidget)) {
    const orderedWidgets = Array.from(root.querySelectorAll('li')).sort(
      (a, b) => getOrder(a) - getOrder(b)
    );
    orderedWidgets.forEach(widget =>
      draggedWidget.parentElement.appendChild(widget)
    );
    updateUserWidgets(orderedWidgets.map(w => w.dataset.widgetId));
    logEvent(
      'widget_reorder_widgets',
      null,
      draggedWidget.dataset.widgetComponent
    );
    overWidget = null;
  }
  resetWidgetOrderAttributes();
  focused.focus(); // Keep focus on the keyboard-drag-button
}

function resetWidgetOrderAttributes() {
  root.querySelectorAll('li').forEach((widget, i) => {
    widget.style.order = i;
  });
}

function getOrder(el) {
  return parseInt(el.style.order || 0);
}

function getIndex(el) {
  return Array.from(root.querySelectorAll('li')).indexOf(el);
}

function getPointer(e) {
  if (e.type === 'touchstart' || e.type === 'touchmove') {
    return e.touches[0];
  } else {
    return e;
  }
}

function updateUserWidgets(orderedWidgetIds) {
  if (!draggedWidget) return;
  _fetch(`/api/user_widgets/?session_id=${window.WidgetFactory.SESSION_ID}`, {
    method: 'PATCH',
    body: JSON.stringify({ widget_ids: orderedWidgetIds }),
  });
}
function destroyUserWidget(widgetId) {
  return _fetch(
    `/api/user_widgets/${widgetId}?session_id=${window.WidgetFactory.SESSION_ID}`,
    {
      method: 'DELETE',
    }
  );
}
async function _fetch(url, options) {
  options = { ...options, headers: { 'Content-Type': 'application/json' } };
  const response = await fetch(url, options);
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }
}
