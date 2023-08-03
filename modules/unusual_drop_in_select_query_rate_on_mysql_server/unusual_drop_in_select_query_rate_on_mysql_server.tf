resource "shoreline_notebook" "unusual_drop_in_select_query_rate_on_mysql_server" {
  name       = "unusual_drop_in_select_query_rate_on_mysql_server"
  data       = file("${path.module}/data/unusual_drop_in_select_query_rate_on_mysql_server.json")
  depends_on = [shoreline_action.invoke_check_repair_tables,shoreline_action.invoke_high_cpu_remediation,shoreline_action.invoke_optimize_server_database]
}

resource "shoreline_file" "check_repair_tables" {
  name             = "check_repair_tables"
  input_file       = "${path.module}/data/check_repair_tables.sh"
  md5              = filemd5("${path.module}/data/check_repair_tables.sh")
  description      = "Database issues, such as corrupt tables or indexes, could cause queries to fail or take longer to complete."
  destination_path = "/agent/scripts/check_repair_tables.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "high_cpu_remediation" {
  name             = "high_cpu_remediation"
  input_file       = "${path.module}/data/high_cpu_remediation.sh"
  md5              = filemd5("${path.module}/data/high_cpu_remediation.sh")
  description      = "Check CPU usage"
  destination_path = "/agent/scripts/high_cpu_remediation.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "optimize_server_database" {
  name             = "optimize_server_database"
  input_file       = "${path.module}/data/optimize_server_database.sh"
  md5              = filemd5("${path.module}/data/optimize_server_database.sh")
  description      = "Optimize the database configuration and server settings to improve performance and reduce the likelihood of future SELECT query rate drops. This can include adjusting cached memory allocation, tuning query timeouts, and optimizing indexes."
  destination_path = "/agent/scripts/optimize_server_database.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_repair_tables" {
  name        = "invoke_check_repair_tables"
  description = "Database issues, such as corrupt tables or indexes, could cause queries to fail or take longer to complete."
  command     = "`chmod +x /agent/scripts/check_repair_tables.sh && /agent/scripts/check_repair_tables.sh`"
  params      = ["DATABASE_NAME"]
  file_deps   = ["check_repair_tables"]
  enabled     = true
  depends_on  = [shoreline_file.check_repair_tables]
}

resource "shoreline_action" "invoke_high_cpu_remediation" {
  name        = "invoke_high_cpu_remediation"
  description = "Check CPU usage"
  command     = "`chmod +x /agent/scripts/high_cpu_remediation.sh && /agent/scripts/high_cpu_remediation.sh`"
  params      = []
  file_deps   = ["high_cpu_remediation"]
  enabled     = true
  depends_on  = [shoreline_file.high_cpu_remediation]
}

resource "shoreline_action" "invoke_optimize_server_database" {
  name        = "invoke_optimize_server_database"
  description = "Optimize the database configuration and server settings to improve performance and reduce the likelihood of future SELECT query rate drops. This can include adjusting cached memory allocation, tuning query timeouts, and optimizing indexes."
  command     = "`chmod +x /agent/scripts/optimize_server_database.sh && /agent/scripts/optimize_server_database.sh`"
  params      = ["DATABASE_NAME","QUERY_TIMEOUT","INDEX_NAME","CACHED_MEMORY_ALLOCATION"]
  file_deps   = ["optimize_server_database"]
  enabled     = true
  depends_on  = [shoreline_file.optimize_server_database]
}

