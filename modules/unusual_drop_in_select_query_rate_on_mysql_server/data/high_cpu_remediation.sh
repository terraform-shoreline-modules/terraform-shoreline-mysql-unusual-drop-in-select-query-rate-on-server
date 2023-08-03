CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then

  echo "High CPU usage detected: $CPU_USAGE%"

  # Perform remediation actions, such as restarting the database service

  systemctl restart mysql

fi