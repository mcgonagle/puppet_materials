class alpha {
  $myname = 'alpha'
  notice("I am ${myname}")
}
class beta {
  include alpha
  $myname = 'beta'
  notice("I am not ${alpha::myname}. I am ${myname}")
}
