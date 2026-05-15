# ─────────────────────────────────────────────
# ASUS battery charge threshold management
# Usage: battery_threshold 80
# ─────────────────────────────────────────────

battery_threshold() {
  if [[ -z "$1" || ! "$1" =~ ^[0-9]+$ || "$1" -lt 20 || "$1" -gt 100 ]]; then
    echo "Usage: battery_threshold <percentage> (20-100)"
    echo "Example: battery_threshold 80"
    return 1
  fi

  # Locate the battery control file (BAT0 or BAT1)
  local bat_path=""
  if [[ -f "/sys/class/power_supply/BAT0/charge_control_end_threshold" ]]; then
    bat_path="/sys/class/power_supply/BAT0/charge_control_end_threshold"
  elif [[ -f "/sys/class/power_supply/BAT1/charge_control_end_threshold" ]]; then
    bat_path="/sys/class/power_supply/BAT1/charge_control_end_threshold"
  else
    echo "❌ Error: Could not find battery control file."
    echo "Checked: /sys/class/power_supply/BAT{0,1}/charge_control_end_threshold"
    echo "Tip: run 'lsmod | grep asus_nb_wmi' to verify the ASUS kernel module is loaded"
    return 1
  fi

  # Apply threshold immediately
  echo "$1" | sudo tee "$bat_path" > /dev/null

  # Write a persistent systemd service so the threshold survives reboots
  local service_file="/etc/systemd/system/battery-threshold.service"
  sudo bash -c "cat > '$service_file' <<EOF
[Unit]
Description=Set ASUS battery charge threshold
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo $1 > $bat_path'

[Install]
WantedBy=multi-user.target
EOF"

  sudo systemctl daemon-reload
  sudo systemctl restart battery-threshold.service
  sudo systemctl enable --now battery-threshold.service > /dev/null 2>&1

  echo "✅ Battery threshold set to $1% (persistent after reboot)"
  echo "Battery path: $bat_path"
}

# Quick read of current threshold
alias battery_check_threshold="(cat /sys/class/power_supply/BAT0/charge_control_end_threshold 2>/dev/null \
  || cat /sys/class/power_supply/BAT1/charge_control_end_threshold 2>/dev/null) \
  || echo 'Could not find battery control file'"
