{ dns, ... }:

with dns.lib.combinators; {
  SOA = {
    nameServer = "ns1";
    adminEmail = "admin@timmitransport.de";
    serial = 2021091600;
  };

  NS = [
    "ns1"
  ];

  A = [ "188.34.177.149" ];
  AAAA = [ "2a01:4f8:c010:b127::1" ];

  subdomains = rec {
    test = host "188.34.177.149" "2a01:4f8:c010:b127::1";
    staging = host "49.12.216.49" "2a01:4f8:c010:214f::1";

    ns1 = test;

    binarycache = test;
    jenkins = test;
    grafana = test;

    prometheus-test = test;
    client-test = test;
    server-test = test;
    mongo-test = test;
    smtp-test = test;
    invoice-test = test;

    prometheus-staging = staging;
    client-staging = staging;
    server-staging = staging;
    invoice-staging = staging;

    de4l = test;
    mqtt = de4l;
    elasticsearch = de4l;
    kibana = de4l;
  };
}
