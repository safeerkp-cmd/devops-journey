#!/bin/bash

echo "===== SERVER HEALTH CHECK ====="

# -------------------------------
# Basic Information
# -------------------------------

date=$(date "+%Y-%m-%d %H:%M:%S")

echo "User : $USER"
echo "Date : $date"

# -------------------------------
# Memory Check
# -------------------------------

total_memory=$(free -m | awk 'NR==2 {print $2}')
available_memory=$(free -m | awk 'NR==2 {print $7}')

memory_usage=$(( (total_memory - available_memory) * 100 / total_memory ))

echo
echo "Memory Usage : $memory_usage%"

if [ "$memory_usage" -gt 90 ]; then
    echo "Memory: WARNING"
else
    echo "Memory: OK"
fi

# -------------------------------
# Disk Check
# -------------------------------

disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

echo
echo "Disk Usage : $disk_usage%"

if [ "$disk_usage" -gt 90 ]; then
    echo "Disk: WARNING"
else
    echo "Disk: OK"
fi

# -------------------------------
# CPU Check
# -------------------------------

cpu_usage=$(top -bn1 | grep "%Cpu" | awk '{
    for(i=1;i<=NF;i++)
        if($i=="id,") {
            gsub(/[^0-9.]/,"",$(i-1))
            printf "%.0f", 100-$(i-1)
        }
}')

echo
echo "CPU Usage : $cpu_usage%"

if [ "$cpu_usage" -gt 90 ]; then
    echo "CPU: WARNING"
else
    echo "CPU: OK"
fi
