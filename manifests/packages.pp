# Install common PHP packages
#
# === Parameters
#
# [*ensure*]
#   Specify which version of PHP packages to install
#
# [*names*]
#   List of the names of the package to install
#
# [*names_to_prefix*]
#   List of packages names that should be prefixed with the common
#   package prefix `$php::package_prefix`
#
class php::packages (
  String $ensure         = $php::ensure,
  Boolean $manage_repos  = $php::manage_repos,
  Array $names_to_prefix = prefix($php::params::common_package_suffixes, $php::package_prefix),
  Array $names           = $php::params::common_package_names,
) inherits php::params {

  assert_private()

  $real_names = union($names, $names_to_prefix)
  if $facts['os']['family'] == 'debian' {
    if $manage_repos {
      include ::apt
      Class['::apt::update'] -> Package[$real_names]
    }
    package { $real_names:
      ensure => $ensure,
    }
  } else {
    notify{ "HERE_1 $ php::install_options == $php::install_options, but still hardcode in manifest":}
    notify{ "HERE_1 $ php::pear == $php::pear, but still hardcode in manifest":}
    package { $real_names:
      ensure => $ensure,
      install_options => [ '--nogpgcheck', '--disablerepo=pe_repo,pc_repo' ]
    }
  }
}
