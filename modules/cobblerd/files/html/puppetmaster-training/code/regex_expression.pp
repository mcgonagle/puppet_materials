$server='blahfoo222'
if $server =~ /.*?foo\d+$/ {
  notice('matches regex')
} else {
  notice('does not match regex')
}
