class profile::app::sqlserver {

  $version = '1.45'

  sqlserver_instance{ 'MSSQLSERVER':
    features                => ['SQL'],
    source                  => 'C:/setup',
    sql_sysadmin_accounts   => [$facts['id']],
  }

  sqlserver::config { 'MSSQLSERVER':
    admin_login_type => 'WINDOWS_LOGIN'
  }

  #Create database
  sqlserver::database{ 'entproduction':
    instance => 'MSSQLSERVER',
  }

  file { 'C:/sqlscripts' :
    ensure => directory,
  }

  file { 'C:/sqlscripts/versiontable.sql' :
    ensure => file,
    owner  => 'Administrator',
    group  => 'Administrators',
    mode   => '0664',
    source => 'puppet:///modules/profile/app/sqlserver/versiontable.sql',
  }

  exec { 'Create version table' :
    command => 'sqlcmd -d entproduction -i C:\sqlscripts\versiontable.sql',
    unless => "sqlcmd -q 'select * from entproduction..versions'",
    path  => 'C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn',
    require => Sqlserver::Database['entproduction'],
  }


 sqlserver_tsql {'Configure version number':
   command => "INSERT INTO VERSIONS(VERSION,DATE) VALUES (${version}, GETDATE())",
   database => 'entproduction',
   onlyif   => "IF (SELECT COUNT(VERSION) FROM VERSIONS WHERE VERSION='${version}' AND DATE=(SELECT MAX(date) FROM VERSIONS)) < 1 THROW 50000, 'update version', 10",
   instance => 'MSSQLSERVER'
 }

}
