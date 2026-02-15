from __future__ import annotations

import platform
from ctypes import POINTER, cast

from comtypes import CLSCTX_ALL, CoInitialize, CoUninitialize
from pycaw.pycaw import AudioUtilities, IAudioEndpointVolume


class VolumeController:
    def __init__(self) -> None:
        self.is_windows = platform.system() == "Windows"
        self._mock_volume = 35
        self._mock_muted = False

    @staticmethod
    def _endpoint_volume():
        CoInitialize()
        devices = AudioUtilities.GetSpeakers()
        interface = devices.Activate(IAudioEndpointVolume._iid_, CLSCTX_ALL, None)
        return cast(interface, POINTER(IAudioEndpointVolume))

    def get_status(self) -> dict[str, int | bool]:
        if not self.is_windows:
            return {"volume": self._mock_volume, "muted": self._mock_muted}

        endpoint = self._endpoint_volume()
        try:
            volume = int(round(endpoint.GetMasterVolumeLevelScalar() * 100))
            muted = bool(endpoint.GetMute())
            return {"volume": volume, "muted": muted}
        finally:
            CoUninitialize()

    def set_volume(self, value: int) -> dict[str, int | bool]:
        value = max(0, min(100, value))

        if not self.is_windows:
            self._mock_volume = value
            return self.get_status()

        endpoint = self._endpoint_volume()
        try:
            endpoint.SetMasterVolumeLevelScalar(value / 100.0, None)
        finally:
            CoUninitialize()
        return self.get_status()

    def step(self, delta: int) -> dict[str, int | bool]:
        current = self.get_status()["volume"]
        return self.set_volume(int(current) + delta)

    def toggle_mute(self) -> dict[str, int | bool]:
        if not self.is_windows:
            self._mock_muted = not self._mock_muted
            return self.get_status()

        endpoint = self._endpoint_volume()
        try:
            now_muted = bool(endpoint.GetMute())
            endpoint.SetMute(not now_muted, None)
        finally:
            CoUninitialize()
        return self.get_status()
