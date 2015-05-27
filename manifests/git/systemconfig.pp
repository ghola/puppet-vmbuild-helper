define vmbuildhelper::git::systemconfig(
  $value,
  $section  = regsubst($name, '^([^\.]+)\.([^\.]+)$','\1'),
  $key      = regsubst($name, '^([^\.]+)\.([^\.]+)$','\2'),
) {
  exec{ "git config --system ${section}.${key} '${value}'":
    environment => inline_template('<%= "HOME=" + ENV["HOME"] %>'),
    path        => ['/usr/bin', '/bin'],
    unless      => "git config --system --get ${section}.${key} '${value}'",
  }
}