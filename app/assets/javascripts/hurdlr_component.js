// Generate table rows from data attributes
const table = document.querySelector('.hurdlr table');
const rows = [
  { label: 'Income', key: 'revenue', value: table.dataset.revenue },
  { label: 'Expenses', key: 'expenses', value: table.dataset.expenses },
  {
    label: 'Taxes',
    key: 'overallTaxAmount',
    value: table.dataset.overallTaxAmount,
  },
  {
    label: 'Profit after tax',
    key: 'afterTaxIncome',
    value: table.dataset.afterTaxIncome,
  },
];
const formatUSD = new Intl.NumberFormat('en-US', {
  style: 'currency',
  currency: 'USD',
  minimumFractionDigits: 0,
  maximumFractionDigits: 0,
});
const tbody = table.querySelector('tbody');
rows.forEach(row => {
  const tr = document.createElement('tr');
  let percent = (row.value / table.dataset.revenue) * 100;
  if (isNaN(percent)) percent = 0;
  tr.innerHTML = `
    <td aria-labelledby="metric-heading" id="${row.key}-label">
      <div class="relative bg-bar overflow-hidden rounded h-32">
        <!-- Dark label outside bar (visible to screen readers) -->
        <span class="absolute top-0 flex px-8 h-full items-center whitespace-nowrap transition-opacity opacity-0 duration-200" data-percent="${percent}">
          ${row.label}
        </span>
        <div class="bg-bar-fill relative inline-block h-full overflow-hidden rounded transform origin-left scale-x-0 transition-transform duration-200" style="width: ${percent}%">
          <!-- White label inside bar (hidden from screen readers, but provides contrast) -->
          <span aria-hidden="true" class="invisible text-white flex px-8 h-full items-center whitespace-nowrap transition-opacity opacity-0 duration-200">
            ${row.label}
          </span>
        </div>
      </div>
    </td>
    <td class="align-middle" aria-labelledby="amount-heading ${row.key}-label">
      ${formatUSD.format(row.value)}
    </td>
  `;
  tbody.appendChild(tr);
});

// Move labels onto the bar if they do not fit to the right
const observer = new ResizeObserver(() => {
  const labels = table.querySelectorAll('.bg-bar > span');
  labels.forEach(label => {
    const percentNeeded =
      (label.offsetWidth / label.parentElement.offsetWidth) * 100;
    const percentAvailable = 100 - label.dataset.percent;
    const inBarLabel = label.nextElementSibling.querySelector('span');
    label.classList.remove('opacity-0'); // Fade in labels
    inBarLabel.classList.remove('opacity-0');
    if (percentNeeded > percentAvailable) {
      label.style.left = '0';
      inBarLabel.classList.remove('invisible');
    } else {
      label.style.left = `${label.dataset.percent}%`;
      inBarLabel.classList.add('invisible');
    }
  });
});
setTimeout(() => {
  table.querySelectorAll('.scale-x-0').forEach(el => {
    el.classList.remove('scale-x-0'); // Animate bars
  });
  observer.observe(table);
}, 100); // Wait for bars to render

// Log analytics event when user clicks sign up
const signUpLink = document.querySelector('.hurdlr .sign-up');
if (signUpLink) {
  signUpLink.addEventListener('click', () => {
    window.WidgetFactory.logEvent('widget_click_sign_up', null, 'hurdlr');
  });
}
