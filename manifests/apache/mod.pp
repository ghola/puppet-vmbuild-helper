define vmbuildhelper::apache::mod {
    if ! defined(Class["apache::mod::${name}"]) {
        class { "::apache::mod::${name}": }
    }
}