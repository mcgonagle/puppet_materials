include service

service::port {
  "talk":
    port => 253;
  "talk2":
    port => 2532,
    udp => false;
  "myotherservice":
    port => 1234;
} # service::port
