#
# Profile to configure Puppet development tools for an
# end windows workstation
#
class profile::workstation::windows::puppet_developer {

  include chocolatey

  ##
  # Basic packages for development
  #
  $dev_packages = [
    'atom',
    'git',
    'notepadplusplus',
    #'pe-client-tools', - to do
    'ruby',
    'vim',
    'visualstudiocode',
  ]

  $dev_packages.each | String $pkg | {
    if !defined( Package[$pkg] ) {
      package { $pkg :
        ensure =>  present,
      }
    }
  }

  ##
  # Add the vscode extension
  #
  vscode_extension { 'jpogran.puppet-vscode':
    ensure  => 'present',
    require => Package['visualstudiocode'],
  }

  ##
  # For puppet linting and r10k
  #
  package { ['puppet-lint', 'r10k'] :
    ensure   => present,
    provider => 'gem',
  }

  ##
  # Configure hiera-eyaml tools
  #
  package { 'hiera-eyaml':
    ensure   => present,
    provider => 'gem',
  }

  ##
  # Add eyaml to the path
  #
  windows_env { 'PATH=C:\Program Files\Puppet Labs\Puppet\sys\ruby\bin':
    mergemode => append,
  }

  ##
  # Transfer a .pp file and relative configurations on the workstation.
  # This file needs to run with the command:
  # `puppet apply C:\ProgramData\puppet_dev\puppet_dev_setup.pp`
  # when the user is logged in to their local account on their desktop
  # This is a post run step to finish the setup
  #
  $puppet_dev_path = 'C:/ProgramData/puppet_dev'
  file { [ $puppet_dev_path, "${puppet_dev_path}/eyaml"]:
    ensure => directory,
  }

  file { "${puppet_dev_path}/puppet_dev_setup.pp":
    ensure => file,
    source => 'puppet:///modules/profile/workstation/puppet_dev_setup.pp'
  }

  ##
  # Public key for eyaml
  #
  file { "${puppet_dev_path}/eyaml/public_key.pkcs7.pem" :
    ensure => file,
    source => 'puppet:///modules/profile/workstation/eyaml_public_key.pem',
  }

  ##
  # Place the pre-commit hook on the system.
  # Note this should be copied into .git/hooks/pre-commit
  # wherever the source control repository is cloned on the
  # developer station
  file { "${puppet_dev_path}/pre-commit" :
    ensure => file,
    source => 'puppet:///modules/profile/workstation/pre-commit',
  }

}
