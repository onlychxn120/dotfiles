#!/usr/bin/env python3
import subprocess
import json
import re


def get_connected_devices():
    try:
        result = subprocess.run(
            ["bluetoothctl", "devices", "Connected"],
            capture_output=True,
            text=True,
            check=True,
        )
        return result.stdout.strip().split("\n") if result.stdout.strip() else []
    except Exception:
        return []


def get_battery_for_device(device_mac):
    try:
        result = subprocess.run(
            ["bluetoothctl", "info", device_mac],
            capture_output=True,
            text=True,
            check=True,
        )
        for line in result.stdout.split("\n"):
            if "Battery Percentage" in line:
                # Try to find percentage in parentheses first (e.g., 0x64 (100))
                match = re.search(r"Battery Percentage:.*?\((?P<percent>\d+)\)", line)
                if not match:
                    # Fallback to simple decimal (e.g., 100)
                    match = re.search(r"Battery Percentage:\s*(?P<percent>\d+)", line)

                if match:
                    return f"{match.group('percent')}%"
        return None
    except Exception:
        return None


def get_device_name(device_mac):
    try:
        result = subprocess.run(
            ["bluetoothctl", "info", device_mac],
            capture_output=True,
            text=True,
            check=True,
        )
        for line in result.stdout.split("\n"):
            if "Name:" in line:
                return line.split("Name:")[1].strip()
        return device_mac
    except Exception:
        return device_mac


def main():
    connected = get_connected_devices()
    devices = []

    for line in connected:
        if line.strip():
            parts = line.split()
            if len(parts) >= 2:
                mac = parts[1]
                name = get_device_name(mac)
                battery = get_battery_for_device(mac)
                devices.append({"name": name, "battery": battery})

    if devices:
        icon = ""
        text = f"{icon}{len(devices)}"
        tooltip_lines = []
        for d in devices:
            bat = d["battery"] if d["battery"] else "—"
            tooltip_lines.append(f"{d['name']} — {bat}")
        tooltip = "\n".join(tooltip_lines)
    else:
        icon = "󰂲"
        text = icon
        tooltip = "No devices connected"

    output = {"text": text, "tooltip": tooltip}

    print(json.dumps(output))


if __name__ == "__main__":
    main()

