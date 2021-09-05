{ dns, ... }:

with dns.lib.combinators; {
  SOA = {
    nameServer = "ns1";
    adminEmail = "admin@timmitransport.de";
    serial = 2021090100;
  };

  NS = [
    "ns1"
  ];

  A = [ "188.34.177.149" ];
  AAAA = [ "fe80::9400:ff:fed7:7117" ];

  subdomains = rec {
    test = host "188.34.177.149" "fe80::9400:ff:fed7:7117";

    ns1 = test;

    binarycache = test;
    jenkins = test;

    prometheus = test;
    grafana = test;

    staging = test;
    client-staging = staging;
    server-staging = staging;
    mongo-staging = staging;
    smtp-staging = staging;
  };
}
