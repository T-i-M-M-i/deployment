{ dns, ... }:

with dns.lib.combinators; {
  SOA = {
    nameServer = "ns1";
    adminEmail = "admin@timmitransport.de";
    serial = 2021090700;
  };

  NS = [
    "ns1"
  ];

  A = [ "188.34.177.149" ];
  AAAA = [ "fe80::9400:ff:fed7:7117" ];

  subdomains = rec {
    test = host "188.34.177.149" "fe80::9400:ff:fed7:7117";
    staging = test;  ## TODO

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
