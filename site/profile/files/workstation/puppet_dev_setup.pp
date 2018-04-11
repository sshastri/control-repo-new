##
# The purpose of this file is to set up tools for a local user workstation
# User should run `puppet apply C:\ProgramData\puppet_dev\puppet_dev_setup.pp`
# from a Powershell prompt
# Tested on Windows 2012R2.
#

##
# Add the vscode extension for the user
#
$extension_name = 'jpogran.puppet-vscode'

exec { "install-vscode-extension-${extension_name}":
  command   => "code.cmd --install-extension ${extension_name}",
  unless    => "cmd.exe /c \"code.cmd --list-extensions --show-versions | findstr.exe ${extension_name}\"",
  path      => 'C:/Windows/System32;C:/Program Files (x86)/Microsoft VS Code/bin',
  logoutput => true,
}

##
# Find the identity of the local user
# Note Windows 7 does not have identity
case $facts['os']['release']['major'] {
  '7': {
    $user_id = $facts['id']
  }
  '2012 R2', '10': {
    $user_id = $facts['identity']['user']
  }
  default: {
    fail ("Could not detect identity for operating system: ${facts['os']['release']['major']} ")
  }
}

$localuser = split($user_id, '\\\\')[1]
$homepath  = "C:/Users/${localuser}"

##
# Setup eyaml configuration directory and file
#
file { "${homepath}/.eyaml":
  ensure => directory,
}

$keypath = "${homepath}/keys/public_key.pkcs7.pem"
$eyaml_config = "---
pkcs7_public_key: '${keypath}'\n
"

file { "${homepath}/.eyaml/config.yaml":
  ensure => file,
  content => $eyaml_config,
}

##
# Setup the keys directory for eyaml keys
#
file { "${homepath}/keys":
  ensure => directory,
}

##
# Place the public encryption key in expected location
#
$eyaml_path = 'C:/ProgramData/puppet_dev/eyaml'

file { $keypath:
  ensure => file,
  content => file("${eyaml_path}/public_key.pkcs7.pem"),
  mode   => '0664',
}
