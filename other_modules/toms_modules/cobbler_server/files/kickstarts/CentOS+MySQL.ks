#platform=x86, AMD64, or Intel EM64T
# System authorization information
auth  --useshadow  --enablemd5
# System bootloader configuration
bootloader --location=mbr
# Partition clearing information
clearpart --all --initlabel
# Use text mode install
#text
# Use cmdline mode install
cmdline
# Firewall configuration
firewall --disabled
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard us
# System language
lang en_US
# Use network installation
url --url=$tree
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
$yum_repo_stanza
# Network information
$SNIPPET('network_config')
# Reboot after installation
reboot

#Root password
rootpw --iscrypted $default_password_crypted
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx
# System timezone
timezone  America/New_York
# Install OS instead of upgrade
install
#default partitioning
$SNIPPET('default_partition_scheme') 
logvol /var/lib/mysql --fstype ext3 --size=${mysql_data_dir} --vgname=vg00 --name=lvSql00  
logvol /var/log/mysql --fstype ext3 --size=51200 --vgname=vg00 --name=lvSqlLog00  
%pre
$SNIPPET('log_ks_pre')
$kickstart_start
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')
# packages_to_install
$SNIPPET('packages_to_install')
$SNIPPET('func_install_if_enabled')
#Installing MySQL-Enterprise
MySQL-server-community
MySQL-client-community
#
%post
$SNIPPET('log_ks_post')
# Start yum configuration 
$yum_config_stanza
# End yum configuration
#disable mysql from starting at initial bootime
/sbin/chkconfig --del mysql
#
$SNIPPET('post_install_kernel_options')
$SNIPPET('post_install_network_config')
$SNIPPET('post_puppet_install')
$SNIPPET('post_yum_cleanup')
$SNIPPET('func_register_if_enabled')
$SNIPPET('download_config_files')
$SNIPPET('koan_environment')
$SNIPPET('redhat_register')
$SNIPPET('cobbler_register')
# Enable post-install boot notification
$SNIPPET('post_anamon')
# Start final steps
$kickstart_done
# End final steps
