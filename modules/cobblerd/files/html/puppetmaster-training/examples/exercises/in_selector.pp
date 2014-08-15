file {'/tmp/os':
  content => $operatingsystem ? {
    'Redhat' => 'Redhat is the best OS ever',
    default  => 'not Redhat, :('
  },
}
