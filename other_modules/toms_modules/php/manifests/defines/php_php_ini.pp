# php_ini.php
#
#
# Function(s) for configuring php.ini
# Created 10/2009 wflynn.  Inspired by mysql_instance.pp
#

define php::php_ini (
  # Allow the <? tag.  Otherwise, only <?php and <script> tags are recognized.
  # NOTE: Using short tags should be avoided when developing applications or
  # libraries that are meant for redistribution, or deployment on PHP
  # servers which are not under your control, because short tags may not
  # be supported on the target server. For portable, redistributable code,
  # be sure not to use short tags.
  $short_open_tag = "On",


  # The number of significant digits displayed in floating point numbers.
  $precision = "14",


  # Output buffering allows you to send header lines (including cookies) even
  # after you send body content, at the price of slowing PHP's output layer a
  # bit.  You can enable output buffering during runtime by calling the output
  # buffering functions.  You can also enable output buffering for all files by
  # setting this directive to On.  If you wish to limit the size of the buffer
  # to a certain size - you can use a maximum number of bytes instead of 'On', as
  # a value for this directive (e.g., output_buffering=4096).
  $output_buffering = "4096",


  # Transparent output compression using the zlib library
  # Valid values for this option are 'off', 'on', or a specific buffer size
  # to be used for compression (default is 4KB)
  # Note: Resulting chunk size may vary due to nature of compression. PHP
  #       outputs chunks that are few hundreds bytes each as a result of
  #       compression. If you prefer a larger chunk size for better
  #       performance, enable output_buffering in addition.
  # Note: You need to use zlib.output_handler instead of the standard
  #       output_handler, or otherwise the output will be corrupted.
  $zlib_output_compression = "Off",


  # When floats & doubles are serialized store serialize_precision significant
  # digits after the floating point. The default value ensures that when floats
  # are decoded with unserialize, the data will remain the same.
  $serialize_precision = "100",


  # Whether to enable the ability to force arguments to be passed by reference
  # at function call time.  This method is deprecated and is likely to be
  # unsupported in future versions of PHP/Zend.  The encouraged method of
  # specifying which arguments should be passed by reference is in the function
  # declaration.  You're encouraged to try and turn this option Off and make
  # sure your scripts work properly with it in order to ensure they will work
  # with future versions of the language (you will receive a warning each time
  # you use this feature, and the argument will be passed by value instead of by
  # reference).
  $allow_call_time_pass_reference = "Off",


  # Determines the size of the realpath cache to be used by PHP. This value should
  # be increased on systems where PHP opens many files to reflect the quantity of
  # the file operations performed.
  $realpath_cache_size = "256k",


  # Decides whether PHP may expose the fact that it is installed on the server
  # (e.g. by adding its signature to the Web server header).  It is no security
  # threat in any way, but it makes it possible to determine whether you use PHP
  # on your server or not.
  $expose_php = "On",


  # Maximum execution time of each script, in seconds
  $max_execution_time = "90",


  # Maximum amount of time each script may spend parsing request data
  $max_input_time = "60",


  # Maximum amount of memory a script may consume (128MB)
  $memory_limit = "128M",


  # error_reporting is a bit-field.  Or each number up to get desired error
  # reporting level
  # E_ALL             - All errors and warnings (doesn't include E_STRICT)
  # E_ERROR           - fatal run-time errors
  # E_RECOVERABLE_ERROR  - almost fatal run-time errors
  # E_WARNING         - run-time warnings (non-fatal errors)
  # E_PARSE           - compile-time parse errors
  # E_NOTICE          - run-time notices (these are warnings which often result
  #                     from a bug in your code, but it's possible that it was
  #                     intentional (e.g., using an uninitialized variable and
  #                     relying on the fact it's automatically initialized to an
  #                     empty string)
  # E_STRICT          - run-time notices, enable to have PHP suggest changes
  #                     to your code which will ensure the best interoperability
  #                     and forward compatibility of your code
  # E_CORE_ERROR      - fatal errors that occur during PHP's initial startup
  # E_CORE_WARNING    - warnings (non-fatal errors) that occur during PHP's
  #                     initial startup
  # E_COMPILE_ERROR   - fatal compile-time errors
  # E_COMPILE_WARNING - compile-time warnings (non-fatal errors)
  # E_USER_ERROR      - user-generated error message
  # E_USER_WARNING    - user-generated warning message
  # E_USER_NOTICE     - user-generated notice message
  $error_reporting = "E_ALL",


  # Print out errors (as a part of the output).  For production web sites,
  # you're strongly encouraged to turn this feature off, and use error logging
  # instead (see below).  Keeping display_errors enabled on a production web site
  # may reveal security information to end users, such as file paths on your Web
  # server, your database schema or other information.
  # possible values for display_errors:
  # Off          - Do not display any errors
  # stderr       - Display errors to STDERR (affects only CGI/CLI binaries!)
  # On or stdout - Display errors to STDOUT (default)
  $display_errors = "Off",


  # Even when display_errors is on, errors that occur during PHP's startup
  # sequence are not displayed.  It's strongly recommended to keep
  # display_startup_errors off, except for when debugging.
  $display_startup_errors = "Off",


  # Log errors into a log file (server-specific log, stderr, or error_log (below))
  # As stated above, you're strongly advised to use error logging in place of
  # error displaying on production web sites.
  $log_errors = "On",


  # Set maximum length of log_errors. In error_log information about the source is
  # added. The default is 1024 and 0 allows to not apply any maximum length at all.
  $log_errors_max_len = "1024",


  # Do not log repeated messages. Repeated errors must occur in same file on same
  # line unless ignore_repeated_source is set true.
  $ignore_repeated_errors = "Off",


  # Ignore source of message when ignoring repeated messages. When this setting
  # is On you will not log errors with repeated messages from different files or
  # source lines.
  $ignore_repeated_source = "Off",


  # If this parameter is set to Off, then memory leaks will not be shown (on
  # stdout or in the log). This has only effect in a debug compile, and if
  # error reporting includes E_WARNING in the allowed list
  $report_memleaks = "On",


  # Store the last error/warning message in $php_errormsg (boolean).
  $track_errors = "Off",


  # Log errors to specified file or syslog.
  $error_log = "/var/log/php.log",


  # This directive describes the order in which PHP registers GET, POST, Cookie,
  # Environment and Built-in variables (G, P, C, E & S respectively, often
  # referred to as EGPCS or GPC).  Registration is done from left to right, newer
  # values override older values.
  $variables_order = "GPCS",


  # Whether or not to register the EGPCS variables as global variables.  You may
  # want to turn this off if you don't want to clutter your scripts' global scope
  # with user data.  This makes most sense when coupled with track_vars - in which
  # case you can access all of the GPC variables through the $HTTP_*_VARS[],
  # variables.
  # You should do your best to write your scripts so that they do not require
  # register_globals to be on#  Using form variables as globals can easily lead
  # to possible security problems, if the code is not very well thought of.
  $register_globals = "Off",


  # Whether or not to register the old-style input arrays, HTTP_GET_VARS
  # and friends.  If you're not using them, it's recommended to turn them off,
  # for performance reasons.
  $register_long_arrays = "Off",


  # This directive tells PHP whether to declare the argv&argc variables (that
  # would contain the GET information).  If you don't use these variables, you
  # should turn it off for increased performance.
  $register_argc_argv = "Off",


  # When enabled, the SERVER and ENV variables are created when they're first
  # used (Just In Time) instead of when the script starts. If these variables
  # are not used within a script, having this directive on will result in a
  # performance gain. The PHP directives register_globals, register_long_arrays,
  # and register_argc_argv must be disabled for this directive to have any affect.
  $auto_globals_jit = "On",


  # Maximum size of POST data that PHP will accept.
  $post_max_size = "8M",


  # Magic quotes for incoming GET/POST/Cookie data.
  $magic_quotes_gpc = "Off",


  # Magic quotes for runtime-generated data, e.g. data from SQL, from exec(), etc.
  $magic_quotes_runtime = "Off",


  # Use Sybase-style magic quotes (escape ' with '' instead of \').
  $magic_quotes_sybase = "Off",


  # Automatically add files before any PHP document.
  $auto_prepend_file = "",


  # Automatically add files after any PHP document.
  $auto_append_file = "",


  # PHP's built-in default is text/html
  $default_mimetype = "text/html",


  # UNIX: "/path1:/path2"
  $include_path = ".",


  # Directory in which the loadable extensions (modules) reside.
  $extension_dir = "/usr/lib64/php/modules",


  # Whether or not to enable the dl() function.  The dl() function does NOT work
  # properly in multithreaded servers, such as IIS or Zeus, and is automatically
  # disabled on them.
  $enable_dl = "On",


  # Whether to allow HTTP file uploads.
  $file_uploads = "On",


  # Temporary directory for HTTP uploaded files (will use system default if not
  # specified).
  $upload_tmp_dir = "/tmp",


  # Maximum allowed size for uploaded files.
  $upload_max_filesize = "2M",


  # Whether to allow the treatment of URLs (like http:// or ftp://) as files.
  $allow_url_fopen = "On",


  # Whether to allow include/require to open URLs (like http:// or ftp://) as files.
  $allow_url_include = "Off",


  # Default timeout for socket based streams (seconds)
  $default_socket_timeout = "60",


  # Unix Extensions (Array)
  $php_extensions = [ "memcache.so", "apc.so", "pdo.so", "imagick.so", "json.so", "mbstring.so" ],

  # Zend Extensions (array)
  $zend_extensions = [ ],

  # Whether or not to define the various syslog variables (e.g. $LOG_PID,
  # $LOG_CRON, etc.).  Turning it off is a good idea performance-wise.  In
  # runtime, you can define these variables by calling define_syslog_variables().
  $define_syslog_variables = "Off",


  # For Unix only.  You may supply arguments as well (default: "sendmail -t -i").
  $sendmail_path = "/usr/sbin/sendmail -t -i",


  # SQL Safe Mode
  $sql_safe_mode = "Off",


  # Allow or prevent persistent links.
  $odbc_allow_persistent = "On",


  # Check that a connection is still valid before reuse.
  $odbc_check_persistent = "On",


  # Maximum number of persistent links.  -1 means no limit.
  $odbc_max_persistent = "-1",


  # Maximum number of links (persistent + non-persistent).  -1 means no limit.
  $odbc_max_links = "-1",


  # Handling of LONG fields.  Returns number of bytes to variables.  0 means
  # passthru.
  $odbc_defaultlrl = "4096",


  # Handling of binary data.  0 means passthru, 1 return as is, 2 convert to char.
  # See the documentation on odbc_binmode and odbc_longreadlen for an explanation
  # of uodbc.defaultlrl and uodbc.defaultbinmode
  $odbc_defaultbinmode = "1",


  # Allow or prevent persistent links.
  $mysql_allow_persistent = "On",


  # Maximum number of persistent links.  -1 means no limit.
  $mysql_max_persistent = "-1",


  # Maximum number of links (persistent + non-persistent).  -1 means no limit.
  $mysql_max_links = "-1",


  # Default port number for mysql_connect().  If unset, mysql_connect() will use
  # the $MYSQL_TCP_PORT or the mysql-tcp entry in /etc/services or the
  # compile-time value defined MYSQL_PORT (in that order).  Win32 will only look
  # at MYSQL_PORT.
  $mysql_default_port = "",


  # Default socket name for local MySQL connects.  If empty, uses the built-in
  # MySQL defaults.
  $mysql_default_socket = "",


  # Default host for mysql_connect() (doesn't apply in safe mode).
  $mysql_default_host = "",


  # Default user for mysql_connect() (doesn't apply in safe mode).
  $mysql_default_user = "",


  # Default password for mysql_connect() (doesn't apply in safe mode).
  # Note that this is generally a *bad* idea to store passwords in this file.
  # *Any* user with PHP access can run 'echo get_cfg_var("mysql.default_password")
  # and reveal this password!  And of course, any users with read access to this
  # file will be able to reveal the password as well.
  $mysql_default_password = "",


  # Maximum time (in seconds) for connect timeout. -1 means no limit
  $mysql_connect_timeout = "60",


  # Trace mode. When trace_mode is active (=On), warnings for table/index scans and
  # SQL-Errors will be displayed.
  $mysql_trace_mode = "Off",


  # Maximum number of links.  -1 means no limit.
  $mysqli_max_links = "-1",


  # Default port number for mysqli_connect().  If unset, mysqli_connect() will use
  # the $MYSQL_TCP_PORT or the mysql-tcp entry in /etc/services or the
  # compile-time value defined MYSQL_PORT (in that order).  Win32 will only look
  # at MYSQL_PORT.
  $mysqli_default_port = "3306",


  # Default socket name for local MySQL connects.  If empty, uses the built-in
  # MySQL defaults.
  $mysqli_default_socket = "",


  # Default host for mysql_connect() (doesn't apply in safe mode).
  $mysqli_default_host = "",


  # Default user for mysql_connect() (doesn't apply in safe mode).
  $mysqli_default_user = "",


  # Default password for mysqli_connect() (doesn't apply in safe mode).
  # Note that this is generally a *bad* idea to store passwords in this file.
  # *Any* user with PHP access can run 'echo get_cfg_var("mysqli.default_pw")
  # and reveal this password!  And of course, any users with read access to this
  # file will be able to reveal the password as well.
  $mysqli_default_pw = "",


  # Allow or prevent reconnect
  $mysqli_reconnect = "Off",


  # Handler used to store/retrieve data.
  $session_save_handler = "files",


  # Argument passed to save_handler.  In the case of files, this is the path
  # where data files are stored. Note: Windows users have to change this
  # variable in order to use PHP's session functions.
  # As of PHP 4.0.1, you can define the path as:
  #     session.save_path = "N;/path"
  # where N is an integer.  Instead of storing all the session files in
  # /path, what this will do is use subdirectories N-levels deep, and
  # store the session data in those directories.  This is useful if you
  # or your OS have problems with lots of files in one directory, and is
  # a more efficient layout for servers that handle lots of sessions.
  # NOTE 1: PHP will not create this directory structure automatically.
  #         You can use the script in the ext/session dir for that purpose.
  # NOTE 2: See the section on garbage collection below if you choose to
  #         use subdirectories for session storage
  # The file storage module creates files using mode 600 by default.
  # You can change that by using
  #     session.save_path = "N;MODE;/path"
  # where MODE is the octal representation of the mode. Note that this
  # does not overwrite the process's umask.
  # session.save_path = "/tmp"
  $session_save_path = "/tmp",


  # Whether to use cookies.
  $session_use_cookies = "1",


  # This option enables administrators to make their users invulnerable to
  # attacks which involve passing session ids in URLs; defaults to 0.
  $session_use_only_cookies = "0",


  # Name of the session (used as cookie name).
  $session_name = "PHPSESSID",


  # Initialize session on request startup.
  $session_auto_start = "0",


  # Lifetime in seconds of cookie or, if 0, until browser is restarted.
  $session_cookie_lifetime = "0",


  # The path for which the cookie is valid.
  $session_cookie_path = "/",


  # The domain for which the cookie is valid.
  $session_cookie_domain = "",


  # Whether or not to add the httpOnly flag to the cookie, which makes it inaccessible to browser scripting languages such as JavaScript.
  $session_cookie_httponly = "",


  # Handler used to serialize data.  php is the standard serializer of PHP.
  $session_serialize_handler = "php",


  # Define the probability that the 'garbage collection' process is started
  # on every session initialization.
  # The probability is calculated by using gc_probability/gc_divisor,
  # e.g. 1/100 means there is a 1% chance that the GC process starts
  # on each request.
  $session_gc_probability = "1",
  $session_gc_divisor = "1000",


  # After this number of seconds, stored data will be seen as 'garbage' and
  # cleaned up by the garbage collection process.
  $session_gc_maxlifetime = "1440",


  # PHP 4.2 and less have an undocumented feature/bug that allows you to
  # to initialize a session variable in the global scope, albeit register_globals
  # is disabled.  PHP 4.3 and later will warn you, if this feature is used.
  # You can disable the feature and the warning separately. At this time,
  # the warning is only displayed, if bug_compat_42 is enabled.
  $session_bug_compat_42 = "0",
  $session_bug_compat_warn = "1",


  # Check HTTP Referer to invalidate externally stored URLs containing ids.
  # HTTP_REFERER has to contain this substring for the session to be
  # considered as valid.
  $session_referer_check = "",


  # How many bytes to read from the file.
  $session_entropy_length = "0",


  # Specified here to create the session id.
  $session_entropy_file = "",


  # Set to {nocache,private,public,} to determine HTTP caching aspects
  # or leave this empty to avoid sending anti-caching headers.
  $session_cache_limiter = "nocache",


  # Document expires after n minutes.
  $session_cache_expire = "180",


  # Select a hash function
  # 0: MD5   (128 bits)
  # 1: SHA-1 (160 bits)
  $session_hash_function = "0",


  # Define how many bits are stored in each character when converting
  # the binary hash data to something readable.
  # 4 bits: 0-9, a-f
  # 5 bits: 0-9, a-v
  # 6 bits: 0-9, a-z, A-Z, "-", ","
  $session_hash_bits_per_character = "5",


  # The URL rewriter will look for URLs in a defined set of HTML tags.
  # form/fieldset are special# if you include them here, the rewriter will
  # add a hidden <input> field with the info which is otherwise appended
  # to URLs.  If you want XHTML conformity, remove the form entry.
  # Note that all valid entries require a " = ", even if no value follows.
  $url_rewriter_tags = "a=href,area=href,frame=src,input=src,form=fakeentry",


  # Should tidy clean and repair output automatically?
  # WARNING: Do not use this option if you are generating non-html content
  # such as dynamic images
  $tidy_clean_output = "Off",


  # Enables or disables WSDL caching feature.
  $soap_wsdl_cache_enabled = "1",


  # Sets the directory name where SOAP extension will put cache files.
  $soap_wsdl_cache_dir = "/tmp",


  # (time to live) Sets the number of second while cached file will be used instead of original one.
  $soap_wsdl_cache_ttl = "86400",


  # apc.enabled can be set to 0 to disable APC. This is primarily useful when APC is statically compiled into PHP,
  # since there is no other way to disable it (when compiled as a DSO, the extension line in php.ini can just be commented-out).
  $apc_enabled = "1",


  # The number of shared memory segments to allocate for the compiler cache. If APC is running out of shared memory but apc.shm_size is set as high as the system allows, raising this value might prevent APC from exhausting its memory.
  $apc_shm_segments = "1",


  # The size of each shared memory segment in MB. By default, some systems (including most BSD variants) have very low limits on the size of a shared memory segment.
  $apc_shm_size = "100",


  # The optimization level. Zero disables the optimizer, and higher values use more aggressive optimizations. Expect very modest speed improvements. This is experimental.
  $apc_optimization = "0",


  # A "hint" about the number of distinct source files that will be included or requested on your web server.
  # Set to zero or omit if unsure# this setting is mainly useful for sites that have many thousands of source files.
  $apc_num_files_hint = "1000",


  # Just like apc.num_files_hint, a "hint" about the number of distinct user cache variables to store. Set to zero or omit if not sure.
  $apc_user_entries_hint = "4096",


  # The number of seconds a cache entry is allowed to idle in a slot in case this cache entry slot is needed by another entry.
  # Leaving this at zero means that APC's cache could potentially fill up with stale entries while newer entries won't be cached.
  # In the event of a cache running out of available memory, the cache will be completely expunged if ttl is equal to 0.
  # Otherwise, if the ttl is greater than 0, APC will attempt to remove expired entries.
  $apc_ttl = "0",


  # The number of seconds a cache entry is allowed to idle in a slot in case this cache entry slot is needed by another entry.
  # Leaving this at zero means that APC's cache could potentially fill up with stale entries while newer entries won't be cached.
  # In the event of a cache running out of available memory, the cache will be completely expunged if ttl is equal to 0.
  # Otherwise, if the ttl is greater than 0, APC will attempt to remove expired entries.
  $apc_user_ttl = "0",


  # The number of seconds that a cache entry may remain on the garbage-collection list.
  # This value provides a fail-safe in the event that a server process dies while executing a cached source file
  # if that source file is modified, the memory allocated for the old version will not be reclaimed until this TTL reached.
  # Set to zero to disable this feature.
  $apc_gc_ttl = "3600",


  # On by default, but can be set to off and used in conjunction with positive apc.filters so that files are only cached if matched by a positive filter.
  $apc_cache_by_default = "1",


  # A comma-separated list of POSIX extended regular expressions. If any pattern matches the source filename,
  # the file will not be cached. Note that the filename used for matching is the one passed to include/require,
  # not the absolute path. If the first character of the expression is a + then the expression will be additive
  # in the sense that any files matched by the expression will be cached, and if the first character is a - then
  # anything matched will not be cached. The - case is the default, so it can be left off.
  $apc_filters = "NULL",


  # If compiled with MMAP support by using --enable-mmap this is the mktemp-style file_mask to pass to the mmap
  # module for determining whether your mmap'ed memory region is going to be file-backed or shared memory backed.
  # For straight file-backed mmap, set it to something like /tmp/apc.XXXXXX (exactly 6 Xs).
  # To use POSIX-style shm_open/mmap put a .shm somewhere in your mask. e.g. /apc.shm.XXXXXX
  # You can also set it to /dev/zero to use your kernel's /dev/zero interface to anonymous mmap'ed memory.
  # Leaving it undefined will force an anonymous mmap.
  $apc_file_mask = "NULL",


  # On very busy servers whenever you start the server or modify files you can create a race of many processes
  # all trying to cache the same file at the same time. This option sets the percentage of processes that will
  # skip trying to cache an uncached file. Or think of it as the probability of a single process to skip caching.
  # For example, setting apc.slam_defense to 75 would mean that there is a 75% chance that the process will not
  # cache an uncached file. So, the higher the setting the greater the defense against cache slams.
  # Setting this to 0 disables this feature.    Deprecated by apc.write_lock.
  $apc_slam_defense = "0",


  # When a file is modified on a live web server it really ought to be done in an atomic manner.
  # That is, written to a temporary file and renamed (mv) the file into its permanent position when it is ready.
  # Many text editors, cp, tar and other such programs don't do this. This means that there is a chance that a
  # file is accessed (and cached) while it is still being written to. This apc.file_update_protection setting puts
  # a delay on caching brand new files. The default is 2 seconds, which means that if the modification timestamp (mtime)
  # on a file shows that it is less than 2 seconds old when it is accessed, it will not be cached. The unfortunate person
  # who accessed this half-written file will still see weirdness, but at least it won't persist. If all of the webserver's
  # files are atomically updated, via some method like rsync (which updates correctly), this protection can be disabled by
  # setting this directive to 0. If the system is flooded with i/o and some update procedures are taking longer than 2 seconds,
  # this setting should be increased to enable the protection on those slower update operations.
  $apc_file_update_protection = "2",


  # Mostly for testing and debugging. Setting this enables APC for the CLI version of PHP.
  # Under normal circumstances, it is not ideal to create, populate and destroy the APC cache on every CLI request,
  # but for various test scenarios it is useful to be able to enable APC for the CLI version of PHP easily.
  $apc_enable_cli = "0",


  # Prevent files larger than this value from getting cached. Defaults to 1M.
  $apc_max_file_size = "1M",


  # Be careful changing this setting. This defaults to on, forcing APC to stat (check) the script on each request
  # to determine if it has been modified. If it has been modified it will recompile and cache the new version.
  # If this setting is off, APC will not check, which usually means that to force APC to recheck files, the web
  # server will have to be restarted or the cache will have to be manually cleared. Note that FastCGI web server
  # configurations may not clear the cache on restart. On a production server where the script files rarely change,
  # a significant performance boost can be achieved by disabled stats.  For included/required files this option applies
  # as well, but note that for relative path includes (any path that doesn't start with / on Unix) APC has to check in
  # order to uniquely identify the file. If you use absolute path includes APC can skip the stat and use that absolute
  # path as the unique identifier for the file.
  $apc_stat = "0",


  # On busy servers, when the web server is first started, or when many files have been modified at the same time,
  # APC may try to compile and cache the same file multiple times. Write_lock guarantees that only one process will
  # attempt to compile and cache an uncached script. The other processes attempting to use the script will run without
  # using the opcode cache, rather than locking and waiting for the cache to prime.
  $apc_write_lock = "1",


  # Logs any scripts that were automatically excluded from being cached due to early/late binding issues.
  $apc_report_autofilter = "0",


  # Optimize include_once() and require_once() calls and avoid the expensive system calls used.
  $apc_include_once_override = "0",


  # RFC1867 File Upload Progress hook handler is only available if APC was compiled against PHP 5.2.0 or later.
  # When enabled, any file uploads which includes a field called APC_UPLOAD_PROGRESS before the file field in an
  # upload form will cause APC to automatically create an upload_key user cache entry where key is the value of the APC_UPLOAD_PROGRESS form entry.
  $apc_rfc1867 = "0",


  # Key prefix to use for the user cache entry generated by rfc1867 upload progress functionality.
  $apc_rfc1867_prefix = "upload_",


  # Specify the hidden form entry name that activates APC upload progress and specifies the user cache key suffix.
  $apc_rfc1867_name = "APC_UPLOAD_PROGRESS",


  # The frequency that updates should be made to the user cache entry for upload progress.
  # This can take the form of a percentage of the total file size or a size in bytes optionally
  # suffixed with "k", "m", or "g" for kilobytes, megabytes, or gigabytes respectively (case insensitive).
  # A setting of 0 updates as often as possible, which may cause slower uploads.
  $apc_rfc1867_freq = "0",


  # This enables a lock-free local process shadow-cache which reduces lock contention when the cache is being written to.
  $apc_localcache = "0",


  # The size of the local process shadow-cache, should be set to a sufficiently large value, approximately half of apc.num_files_hint.
  $apc_localcache_size = "512",


  # Enables APC handling of signals, such as SIGSEGV, that write core files when signaled.
  # When these signals are received, APC will attempt to unmap the shared memory segment in
  # order to exclude it from the core file. This setting may improve system stability when fatal signals
  # are received and a large APC shared memory segment is configured.
  $apc_coredump_unmap = "0",


  # Verification with ctime will avoid problems caused by programs such as svn or rsync by making sure
  # inodes haven't changed since the last stat. APC will normally only check mtime.
  $apc_stat_ctime = "0",

  # Other Miscellaneous Directives (ARRAY)
  # List of free-form directives entered verbatim per-line at the end of the configuration file
  $other_directives = [],

  ########

  # Ini file to be written
  $php_ini_file = "/etc/php.ini",

  # Ini file template to use
  $php_ini_tpl = "php.ini-allpurpose.tpl",

  # Ini file permissions mode
  $php_ini_mode = "664",

  # Ini file owner
  $php_ini_owner = "root",

  # Ini file group
  $php_ini_group = "root"

  ) {

  file { "$php_ini_file":
    content => template ("php/$php_ini_tpl"),
    mode    => "$php_ini_mode",
    owner   => "$php_ini_owner",
    group   => "$php_ini_group",
  }

}#end of php::php_ini
