class system {
  $operatingsystem = "MyOS"
  notice ("The operating system is: ${operatingsystem}")
}

class truesystem {
  $operatingsystem = "MyOS"
  notice ("The true operating system is: $::operatingsystem")
}
