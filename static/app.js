const slider = document.getElementById('volume-slider');
const volumeText = document.getElementById('volume-text');
const muteText = document.getElementById('mute-text');
const upBtn = document.getElementById('up-btn');
const downBtn = document.getElementById('down-btn');
const muteBtn = document.getElementById('mute-btn');

async function api(path, options = {}) {
  const response = await fetch(path, {
    headers: { 'Content-Type': 'application/json' },
    ...options,
  });
  if (!response.ok) {
    const body = await response.json().catch(() => ({}));
    throw new Error(body.error || '请求失败');
  }
  return response.json();
}

function renderStatus(data) {
  const volume = Number(data.volume);
  const muted = Boolean(data.muted);

  slider.value = String(volume);
  volumeText.textContent = `${volume}%`;
  muteText.textContent = muted ? '静音中' : '有声音';
  muteText.classList.toggle('muted', muted);
}

async function refresh() {
  const data = await api('/api/status');
  renderStatus(data);
}

slider.addEventListener('change', async () => {
  const data = await api('/api/volume', {
    method: 'POST',
    body: JSON.stringify({ value: Number(slider.value) }),
  });
  renderStatus(data);
});

upBtn.addEventListener('click', async () => {
  const data = await api('/api/step', {
    method: 'POST',
    body: JSON.stringify({ delta: 5 }),
  });
  renderStatus(data);
});

downBtn.addEventListener('click', async () => {
  const data = await api('/api/step', {
    method: 'POST',
    body: JSON.stringify({ delta: -5 }),
  });
  renderStatus(data);
});

muteBtn.addEventListener('click', async () => {
  const data = await api('/api/toggle-mute', {
    method: 'POST',
  });
  renderStatus(data);
});

refresh().catch((err) => {
  alert(`初始化失败：${err.message}`);
});
