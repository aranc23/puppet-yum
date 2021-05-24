# Define: yum::config
#
# This definition manages yum.conf
#
# Parameters:
#   [*key*]      - alternative conf. key (defaults to name)
#   [*ensure*]   - specifies value or absent keyword
#   [*section*]  - config section (default to main)
#
# Actions:
#
# Requires:
#   RPM based system
#
# Sample usage:
#   yum::config { 'installonly_limit':
#     ensure => 2,
#   }
#
#   yum::config { 'debuglevel':
#     ensure => absent,
#   }
#
define yum::config (
  Variant[Boolean, Integer, Enum['absent'], String] $ensure,
  String                                            $key     = $title,
) {
  $_ensure = $ensure ? {
    Boolean => bool2num($ensure),
    default => $ensure,
  }

  $_changes = $ensure ? {
    'absent'  => "rm  ${key}",
    default   => "set ${key} '${_ensure}'",
  }

  augeas { "yum.conf_${key}":
    incl    => $yum::config_file,
    lens    => 'Yum.lns',
    context => "/files/${yum::config_file}/main/",
    changes => $_changes,
  }
}
