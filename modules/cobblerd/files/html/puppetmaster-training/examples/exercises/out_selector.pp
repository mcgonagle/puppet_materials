$content = $operatingsystem ? {
  'CentOS' => 'CentOS is the best OS ever',
  default  => 'not CentOS, :('
}

file{'/tmp/os':
  content => $content,
}
