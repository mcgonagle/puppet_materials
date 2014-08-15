class activemq::mcollective inherits activemq {
    File ["/etc/activemq/activemq.xml"] {
        source => "puppet:///modules/activemq/activemq.xml.mcollective", }

    File ["/etc/activemq/activemq-wrapper.xml"] {
        source => "puppet:///modules/activemq/activemq-wrapper.xml.mcollective", }
}
