
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Unusual drop in SELECT query rate on MySQL server
---

This incident type refers to a sudden and abnormal drop in the SELECT query rate on a MySQL server. This can potentially cause disruption in the service and affect the user experience. The cause of the drop could be due to a variety of factors such as database issues, server overload, or network problems. It requires immediate attention and investigation to identify the root cause and resolve the issue to prevent further impact.

### Parameters
```shell
# Environment Variables

export MYSQL_SERVER_IP="PLACEHOLDER"

export DATABASE_NAME="PLACEHOLDER"

export DATABASE_USERNAME="PLACEHOLDER"

export DATABASE_PASSWORD="PLACEHOLDER"

export INDEX_NAME="PLACEHOLDER"

export CACHED_MEMORY_ALLOCATION="PLACEHOLDER"

export QUERY_TIMEOUT="PLACEHOLDER"
```

## Debug

### Check MySQL service status
```shell
systemctl status mysql.service
```

### Check MySQL error log
```shell
tail -n 100 /var/log/mysql/error.log
```

### Check server CPU usage
```shell
top
```

### Check server memory usage
```shell
free -h
```

### Check network connectivity to MySQL server
```shell
ping ${MYSQL_SERVER_IP}
```

### Check MySQL query rate
```shell
mysqladmin -u root -p status | grep 'Queries'
```

### Database issues, such as corrupt tables or indexes, could cause queries to fail or take longer to complete.
```shell
bash

#!/bin/bash



# Step 1: Check for corrupt tables or indexes

corrupt_tables=$(mysql -u ${USERNAME} -p${PASSWORD} -e "CHECK TABLE ${DATABASE_NAME}.*" | grep -i "error" | awk '{print $1}')



if [ -n "$corrupt_tables" ]; then

  echo "Corrupt tables found: $corrupt_tables"

  

  # Step 2: Attempt to repair corrupt tables or indexes

  mysql -u ${USERNAME} -p${PASSWORD} -e "REPAIR TABLE $corrupt_tables"

  

  # Check if repair was successful

  if [ $? -eq 0 ]; then

    echo "Tables repaired successfully"

  else

    # Step 3: If repair is not possible, restore from backup

    echo "Repair failed, restoring from backup"

    # Add command to restore from backup

  fi

else

  echo "No corrupt tables found"

fi


```

## Repair

### Check CPU usage
```shell
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then

  echo "High CPU usage detected: $CPU_USAGE%"

  # Perform remediation actions, such as restarting the database service

  systemctl restart mysql

fi
```

### Optimize the database configuration and server settings to improve performance and reduce the likelihood of future SELECT query rate drops. This can include adjusting cached memory allocation, tuning query timeouts, and optimizing indexes.
```shell


#!/bin/bash



# Set the ${DATABASE_NAME} variable to the name of the database to be optimized

database_name=${DATABASE_NAME}



# Set the ${CACHED_MEMORY_ALLOCATION} variable to the desired amount of memory to allocate for caching

cached_memory_allocation=${CACHED_MEMORY_ALLOCATION}



# Set the ${QUERY_TIMEOUT} variable to the desired amount of time in seconds for query timeouts

query_timeout=${QUERY_TIMEOUT}



# Set the ${INDEX_NAME} variable to the name of the index to be optimized

index_name=${INDEX_NAME}



# Optimize the server settings

mysql -u root -p -e "SET GLOBAL query_cache_size = $cached_memory_allocation;"

mysql -u root -p -e "SET GLOBAL query_cache_type = ON;"

mysql -u root -p -e "SET GLOBAL wait_timeout = $query_timeout;"



# Optimize the database configuration

mysql -u root -p -e "ALTER TABLE $database_name.$index_name ENGINE=InnoDB;"

mysql -u root -p -e "ANALYZE TABLE $database_name.$index_name;"



# Restart the MySQL server to apply the changes

systemctl restart mysql


```