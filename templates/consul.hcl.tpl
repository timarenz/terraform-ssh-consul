datacenter = "${datacenter}"
%{ if primary_datacenter != "false" ~}primary_datacenter = "${primary_datacenter}"%{ endif }
data_dir = "${data_dir}"
%{ if agent_type == "server" ~}
server = true
%{ if bootstrap_expect != 0 ~}bootstrap_expect = ${bootstrap_expect}%{ endif }
performance {
  raft_multiplier = 1
}%{ endif }
%{ if auto_encrypt ~}
auto_encrypt {
  %{ if agent_type == "server" }allow_tls = true%{ endif ~}
  %{ if agent_type == "client" }tls = true%{ endif }
}%{ endif }
%{ if acl ~}
acl {
  enabled = true
  default_policy = "${default_policy}"
  enable_token_persistence = ${enable_token_persistence}
  tokens {
  %{ if agent_token != "" ~}agent = "${agent_token}"%{ endif }
  %{ if agent_type == "server" && master_token != "" ~}master = "${master_token}"%{ endif }
  }
}%{ endif }
retry_join = ${retry_join}
%{ if retry_join_wan != "false" ~}retry_join_wan = ${retry_join_wan}%{ endif }
%{ if encryption_key != "" ~}encrypt = "${encryption_key}"%{ endif }
ui = ${ui}
%{ if serf_lan != "false" ~}serf_lan = "${serf_lan}"%{ endif }
%{ if serf_wan != "false" ~}serf_wan = "${serf_wan}"%{ endif }
%{ if translate_wan_addrs ~}translate_wan_addrs = true%{ endif }
%{ if advertise_addr_wan != "false" ~}advertise_addr_wan = "${advertise_addr_wan}"%{ endif }
%{ if advertise_addr != "false" ~}advertise_addr = "${advertise_addr}"%{ endif }
addresses {
  dns = "%{ if agent_type == "server" }0.0.0.0%{ else }127.0.0.1%{ endif }"
  http = "%{ if agent_type == "server" }0.0.0.0%{ else }127.0.0.1%{ endif }"
  https = "%{ if agent_type == "server" }0.0.0.0%{ else }127.0.0.1%{ endif }"
  grpc = "%{ if agent_type == "server" }0.0.0.0%{ else }127.0.0.1%{ endif }"
}
ports {
  dns = ${dns_port}
  http = ${http_port}
  https = ${https_port}
  grpc = ${grpc_port}
  serf_lan = ${serf_lan_port}
  serf_wan = ${serf_wan_port}
  server = ${server_port}
  sidecar_min_port = ${sidecar_min_port}
  sidecar_max_port = ${sidecar_max_port}
}
%{ if bind_addr != "false" }bind_addr = "${bind_addr}"%{ endif }
%{ if ca_file != "false" }ca_file = "/etc/consul.d/ssl/ca.pem"%{ endif }
%{ if cert_file != "false" }cert_file = "/etc/consul.d/ssl/server.pem"%{ endif }
%{ if key_file != "false" }key_file = "/etc/consul.d/ssl/server.key"%{ endif }
%{ if verify_incoming }verify_incoming = true%{ endif }
%{ if verify_incoming_rpc }verify_incoming_rpc = true%{ endif }
%{ if verify_incoming_https }verify_incoming_https = true%{ endif }
%{ if verify_outgoing }verify_outgoing = true%{ endif }
%{ if verify_server_hostname }verify_server_hostname = true%{ endif }
%{ if agent_type == "client" }%{ if enable_local_script_checks }enable_local_script_checks = true%{ endif }%{ endif }
%{ if enable_central_service_config }enable_central_service_config = true%{ endif }
%{ if connect }
connect {
  enabled = true
  %{ if agent_type == "server" ~}enable_mesh_gateway_wan_federation = ${enable_mesh_gateway_wan_federation}%{ endif }
}
%{ endif }
node_meta {
%{ for k, v in node_meta }
  ${k} = "${v}"
%{ endfor }
}
%{ if agent_type == "client" }
  %{ if segment != "false" }segment = "${segment}"%{ endif }
%{ endif }
%{ if agent_type == "server" }
%{ if audit_log }
audit {
  enabled = true
  sink "audit_log" {
    type   = "file"
    format = "json"
    path   = "/var/log/consul/audit.json"
    delivery_guarantee = "best-effort"
    rotate_duration = "${audit_log_rotate_duration}"
    rotate_max_files = ${audit_log_rotate_max_files}
    rotate_bytes = ${audit_log_rotate_bytes}
  }
}
%{ endif }
autopilot {
%{ for k, v in autopilot }
  ${k} = "${v}"
%{ endfor }
}
segments = [
%{ for s in segments }
  {
  %{ for k,v in s }
    %{ if k == "port"}
      ${k} = ${tonumber(v)},
    %{ else }
      ${k} = "${v}",
    %{ endif }
  %{ endfor }
  },
%{ endfor }
]
%{ endif }
log_level = "${log_level}"
