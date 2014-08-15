class imagick {
  package { "ImageMagick.${architecture}": ensure => latest,}
  package { "ImageMagick2.${architecture}": ensure => latest,}
}
