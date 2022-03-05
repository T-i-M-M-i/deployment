## Domain Names

* To reduce complexity, all servers will use the same `networking.domain` defined at `./modules/dns.nix`
 * The zone is defined in `modules/dns` and is served by all hosts.
* Each hosts `networking.hostName` is defined at `./hosts/$HOST/configuration.nix`, depending on its main purpose (test/staging/productive)
* We try avoid hardcoding urls, but use `${config.networking.fqdn}`
 * For each service, we provide a virtualHost named `"${SERVICE}-${config.networking.fqdn}"` via CNAME
 * Services that are public available at another domain have a vhost defined at `./modules/nginx/timmi-public.nix`


## Services

Overview of resource footprint of running services:

### OS + Bind + Nginx + Prometheus + Loki

* ~0,2GB Ram
* ~0,8GB Ram for maintainance jobs (rebuild, …) + error margin

### Grafana

* ~0,1GB Ram

### Jenkins

* ~1GB Ram

### Mongod

* ~0,1GB Ram (test instance)

### Timmi Pro Server+Client

* ~1GB Ram

### Timmi Invoice Server

* ~0,3GB Ram
* ~0,25GB Ram for `xetex` process

> Invoice run at CX31 caused a load of 1,4

### Cypress

* ~1GB Ram

### Mosquitto

* ~0,006GB Ram

### Elasticsearch

* ~1,5GB Ram
* ~0,25GB Ram for Kibana


## Servers

All servers run at hetzner.cloud at datacenter in Falkenstein

### test

* ci/cd + buildcache
* host latest build of timmi instance (any branch) with test-db
* grafana
* dns

> Hetzner CX31 (*8GB Ram*, 2vCPUs, 80GB SSD => 10,49€/month)

### productive

* host latest build of `master` branch of timmi (client+server+invoice)
  * deployed by hook called from ci, using the buildcache
* for now, we keep the db at cloud.mongodb.com
  * moving it to the productive server might save $9.30 in future
* dns

> Hetzner CX21 (*4GB Ram*, 2vCPUs, 40GB SSD => 5,83€/month)
>  * we will have to evaluate, whether using an invoice build queue with nice+ionice + cgroups is enough to prevent performance impacts on pro server+client during invoice run
>  * when required, a second CX21 or a CX11 will be used as dedicated invoice server

### staging

* host latest build of `staging` branch of timmi (client+server+invoice)
  * deployed by hook called from ci, using the buildcache
  * use the same setup as productive (except a few variables defined at `./sops/secrets/timmi-env`)
* db backups with restic
* dns

> Hetzner CX21 (*4GB Ram*, 2vCPUs, 40GB SSD => 5,83€/month)

### live (proposal)

* on demand start of services from arbitrary feature branches
  * setup subdomain per branch in ci
  * systemd socket activation starts builds copied from buildcache
  * service stopped by timeout, when no requests for defined time
  * oldest instance might be shutdown, to free resources for new instance

> maybe Hetzner CX31 (*8GB Ram*, 2vCPUs, 80GB SSD => 10,49€/month)
