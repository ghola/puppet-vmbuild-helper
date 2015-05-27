# Helps define a php extension using a filesystem file

define vmbuildhelper::php::filemodule($source) {
  $filename = regsubst($source, '^[ ]*/?([^/]+/)*([^/]+)[ ]*$', '\2')
  $extension = regsubst($filename, '^([^\.]+).*$', '\1')

  file { "/usr/lib64/php/modules/$filename":
    source  => $source,
    require => Class['php'],
    notify  => Service['httpd']
  }

  vmbuildhelper::php::ini { 'extension':
    entry        => ".anon/extension",
    value        => "$filename",
    ini_filename => "$extension.ini",
    require      => File["/usr/lib64/php/modules/$filename"]
  }
}