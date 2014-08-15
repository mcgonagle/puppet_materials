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
# Clear the Master Boot Record
zerombr
# Allow anaconda to partition the system as needed
autopart
part /boot --fstype ext3 --size=200 --asprimary
part swap --recommended --ondisk=sda
part pv.01 --size=1024 --grow --ondisk=sda
volgroup vg00 pv.01 
logvol / --fstype ext3 --size=10240 --vgname=vg00 --name=lvRoot00  
logvol /var --fstype ext3 --size=10240 --vgname=vg00 --name=lvVar00
logvol /var/log --fstype ext3 --size=10240 --vgname=vg00 --name=lvVarLog00 
logvol /opt --fstype ext3 --size=5120 --vgname=vg00 --name=lvOpt00 
logvol /tmp --fstype ext3 --size=5120 --vgname=vg00 --name=lvTmp00  

%pre
$SNIPPET('log_ks_pre')
$kickstart_start
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')

%packages --nobase
@core
man
which
sysstat
sudo
bind-utils
mlocate
zsh
tcsh
patch
emacs-nox
joe
redhat-lsb
telnet
rootfiles
ruby
libselinux-ruby
rsyslog
tree
wget
portmap
nfs-utils
autofs
augeas
puppet
$SNIPPET('func_install_if_enabled')

%post
$SNIPPET('log_ks_post')
# Start yum configuration 
$yum_config_stanza
# End yum configuration
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
