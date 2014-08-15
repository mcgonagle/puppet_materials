define download_file(
        $site="",
        $cwd="",
        $creates="",
        $require="",
        $user="") {                                                                                         
    exec { $name:   
        command => "wget ${site}/${name}",                                                         
        cwd => $cwd,
        creates => "${cwd}/${name}",                                                              
        require => $require,
        user => $user,                                                                                                          
    }

}

#download_file { [
#    "python-elementtree-1.2.6-7.el4.rf.i386.rpm", 
#    "python-sqlite-1.0.1-1.2.el4.rf.i386.rpm", 
#    "python-urlgrabber-2.9.7-1.2.el4.rf.noarch.rpm", 
#    "yum-2.4.2-0.4.el4.rf.noarch.rpm" 
#    ]: 
#    site => "http://apt.sw.be/redhat/el4/en/i386/dag/RPMS", 
#    cwd => "${repo_root}/dag/redhat/el4/en/i386/dag/RPMS",
#    creates => "${repo_root}/dag/redhat/el4/en/i386/dag/RPMS/$name",
#    require => File["${repo_root}/dag/redhat/el4/en/i386/dag/RPMS"],
#    user => $repo_owner,                                                                               #}
