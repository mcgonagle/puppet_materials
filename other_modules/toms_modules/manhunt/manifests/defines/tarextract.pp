# tarextract.pp

#***Use tarextract don't use the others***

define manhunt::tarextract(
# source - full path name of tarball
$source, 

# directory - place where want to extract it
$directory,

# newfile - the relative path name of a file contained in the tarball
#   once this exists, it will be used to suppress repetition of extraction
#    every time puppet runs
$newfile,

# uid/gid under which to run the command, if other than root
$uid = false,
$gid = root,

# compression - valid values are gzip, gz, bzip, zip
$compression = none,

# cmd_options - any other options to be passed to the extraction command
$cmd_options = "") {

    $command = $compression ? {
        gzip => "tar xzf $source $cmd_options",
        bzip => "bash -c 'bunzip2 -c $source | tar xf - $cmd_options'",
        zip  => "unzip $cmd_options $source",
        gz  => "gunzip $cmd_options $source",
        default => "tar xf $source $cmd_options",
    }

    exec { "$command":
        cwd     => $directory,
        creates => "$directory/$newfile",
        path    => [ "/bin", "/usr/bin" ],
        user    => $uid ? { false => root, default => $uid },
        group   => $gid
    }
}
