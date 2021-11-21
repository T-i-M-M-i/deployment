{ dns, ... }:

with dns.lib.combinators; {
  SOA = {
    nameServer = "ns1";
    adminEmail = "admin@timmitransport.de";
    serial = 2021112100;
  };

  NS = [
    "ns1"
    "ns2"
    "ns3"
  ];

  #A = [ "157.90.252.51"  ];
  #AAAA = [ "2a01:4f8:1c17:e405::1" ];

  subdomains = rec {
    test = host "188.34.177.149" "2a01:4f8:c010:b127::1";
    staging = host "49.12.216.49" "2a01:4f8:c010:214f::1";
    productive = host "157.90.252.51" "2a01:4f8:1c17:e405::1";

    ns1 = test;
    ns2 = staging;
    ns3 = productive;

    binarycache = test;
    jenkins = test;
    grafana = test;

    prometheus-test = test;
    loki-test = test;
    client-test = test;
    server-test = test;
    mongo-test = test;
    smtp-test = test;
    invoice-test = test;

    prometheus-staging = staging;
    loki-staging = staging;
    client-staging = staging;
    server-staging = staging;
    invoice-staging = staging;

    prometheus-productive = productive;
    loki-productive = productive;
    client-productive = productive;
    server-productive = productive;
    invoice-productive = productive;

    de4l = test;
    mqtt = de4l;
    elasticsearch = de4l;
    kibana = de4l;
  };
}
