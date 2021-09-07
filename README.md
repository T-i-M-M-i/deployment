## Services

### OS + Bind + Nginx + Prometheus + Loki

* ~0,2GB Ram
* ~0,8GB Ram for maintainance jobs (rebuild, …) + error margin

### Mongod

* ~0,1GB Ram (test instance)

### Pro Server+Client

* ~1GB Ram

### Invoice Server

* ~0,5GB Ram
* ~0,5GB Ram for `tex` process (TODO: confirm)

### Cypress

* ~1GB Ram

### Jenkins

* ~1GB Ram

### Grafana

* ~0,1GB Ram

### Mosquitto

* ~0,006GB Ram

### Elasticsearch

* ~1,5GB Ram
* ~0,25GB Ram for Kibana


## Servers

All servers run at hetzner.cloud at datacenter in Falkenstein

### test

* ci + buildcache
* host latest build of timmi instance (any branch) with test-db
* grafana
* dns master

> Hetzner CX31 (*8GB Ram*, 2vCPUs, 80GB SSD => 10,49€/month)
>
> status: setup finished, working well

### productive

* host latest build of `master` branch of timmi (client+server+invoice)
  * deployed by hook called from ci, using the buildcache
* for now, we keep the db at cloud.mongodb.com
  * moving it to the productive server might save $9.30 in future
  * we will setup db backups independent cloud.mongodb.com
* dns slave

> probably Hetzner CX21 (*4GB Ram*, 2vCPUs, 40GB SSD => 5,83€/month)
>  * we will have to evaluate, whether using an invoice build queue with nice+ionice + cgroups is enough to prevent performance impacts on pro server+client during invoice run
>  * when required, a second CX21 or a CX11 will be used as dedicated invoice server
>
> status: setup in progress

### staging

* host latest build of `staging` branch of timmi (client+server+invoice)
  * deployed by hook called from ci, using the buildcache
  * use the same setup as productive (except a few variables)
* dns slave

> probably Hetzner CX21 (*4GB Ram*, 2vCPUs, 40GB SSD => 5,83€/month)
>
> status: setup in progress

### live

* on demand start of arbitrary feature branches
  * setup subdomain per branch in ci
  * systemd socket activation starts builds copied from buildcache
  * service stopped by timeout, when no requests for defined time
  * oldest instance might be shutdown, to free resources for new instance

> maybe Hetzner CX31 (*8GB Ram*, 2vCPUs, 80GB SSD => 10,49€/month)
>
> status: to be decided, lower prio


## TODO

### setup staging+prodctive

- [ ] pure timmi build
  - [ ] pro client production build

### db backups

- [ ] encrypted mongodump to S3

### reproducible servers

The following configuration attributes should be set, to allow the `test` server to be 100% reinstalled from declaration without any need of manual interaction

- [ ] `services.jenkins.plugins`
- [ ] `services.jenkins.jobBuilder`
- [ ] `services.grafana.provision.dashboards`
