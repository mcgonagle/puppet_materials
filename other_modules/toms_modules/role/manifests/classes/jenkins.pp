class role::jenkins inherits role {
 notice("inside $name")
 include users::au_users
 include users::re_users
 include jenkins
 include ant
 include subversion
}
