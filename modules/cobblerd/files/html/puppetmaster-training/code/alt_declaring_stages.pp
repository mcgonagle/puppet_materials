class stages {

  stage { [ "before", "after"]: }
  Stage['before'] -> Stage['main'] -> Stage['after']

}
