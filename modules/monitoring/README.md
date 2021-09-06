## Components

### Grafana
* custom visualization + alerting
* only 1 instance required (deployed at test-server)
* boards can be defined via `services.grafana.provision.dashboards`, for now we only backuped json-exports to ./grafana/boards


### Prometheus
* round robin time series store
* allows pushes, but recommends scraping from /metrics endpoints of exporters

#### Node exporter
* general host state (mem+cpu+network+disk+systemd+filedescriptors+…)

#### Blackbox exporter
* allows connection checks to other hosts (icmp+http+…)
* used to check if http servers are running


### Loki
* efficient log storage
* compatible with prometheus api

#### Promtail
* agent that feeds loki with syslog
