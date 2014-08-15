class stages {

  stage { "before": before => Stage['main'] }
  stage { "after": require => Stage['main'] }

}
