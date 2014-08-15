define yum_repos::yumrepo_define($description,
          $url_type = "base",
                      $url,
          $enabled = "1",
          $gpg_check = "0",
          $meta_data_expire = "1",
          $priority_var = "1") {


if $url_type == "base" {

          yumrepo { "${name}":
           descr           => "${description}",
           baseurl         => "${url}",
           enabled         => "${enabled}",
           gpgcheck        => "${gpg_check}",
           metadata_expire => "${meta_data_expire}",
          } 
}#end of if 
else {
          yumrepo { "${name}":
           descr           => "${description}",
           mirrorlist      => "${url}",
           enabled         => "${enabled}",
           gpgcheck        => "${gpg_check}",
           metadata_expire => "${meta_data_expire}",
          } 
}#end of else statement

}#end of definition
