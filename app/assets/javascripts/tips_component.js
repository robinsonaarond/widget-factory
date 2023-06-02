const root = document.querySelector('.tips');
addCtaClickHandler();

window.addEventListener('message', e => {
  if (e.data.type === 'UPDATE_PREVIEW') updateTip(e);
});

/** Log a CTA click for the tip in nucleus (not related to widget factory analytics) */
function addCtaClickHandler() {
  const button = root.querySelector('mx-button');
  if (!button) return;
  const tipId = root.querySelector('[data-tip-id]').dataset.tipId;
  button.addEventListener('click', _ => {
    window.parent.postMessage(
      { type: 'CTA_CLICK', payload: { component: 'tips', id: tipId } },
      '*'
    );
  });
}

/** Update the tip text and CTA label (from an UPDATE_PREVIEW message from the widget admin form) */
function updateTip(e) {
  const { tip, cta_label, bg } = e.data.payload;
  if (tip !== undefined) root.querySelector('.tip-container p').innerText = tip;
  const button = root.querySelector('mx-button');
  if (cta_label) {
    button.classList.remove('hidden');
    const buttonContent = root.querySelector('mx-button .slot-content');
    if (buttonContent) buttonContent.innerText = cta_label;
  } else if (cta_label !== undefined) {
    button.classList.add('hidden');
  }
  if (bg) {
    const tipBg = root.querySelector('.tip-bg');
    tipBg.style.setProperty('--tip-bg', `var(--tip-bg-${bg})`);
  }
}

// Log a CTA click event in widget analytics
root.addEventListener('click', e => {
  if (e.target.closest('a[target="_blank"]')) {
    window.WidgetFactory.logEvent('widget_click_cta');
  }
});
