class kiwiirc::config(
    $restrict_server           = hiera('kiwi_restrict_server',         $kiwiirc::params::restrict_server),
    $restrict_server_port      = hiera('kiwi_restrict_server_port',    $kiwiirc::params::restrict_server_port),
    $restrict_server_ssl       = hiera('kiwi_restrict_server_ssl',     $kiwiirc::params::restrict_server_ssl),
    $restrict_server_channel   = hiera('kiwi_restrict_server_channel', $kiwiirc::params::restrict_server_channel),
    $restrict_server_channel_key        = hiera('kiwi_restrict_server_channel_key ',     $kiwiirc::params::restrict_server_channel_key ),
    $restrict_server_password  = hiera('kiwi_restrict_server_password',$kiwiirc::params::restrict_server_password),
    $restrict_server_nick      = hiera('kiwi_restrict_server_nick',    $kiwiirc::params::restrict_server_nick),
) inherits kiwiirc::params {
    file {'/opt/kiwiirc/config.js':
        ensure      => file,
        owner       => 'kiwiirc',
        group       => 'kiwiirc',
        content     => template('kiwiirc/config.js.erb'),
        notify      => Service['kiwiirc'],
        require     => Class['kiwiirc::package'],
    } -> 
    gnutls::generate_key{'kiwiirc':
        certfile    => '/opt/kiwiirc/cert.pem',
        keyfile     => '/opt/kiwiirc/server.key',
        user        => 'kiwiirc',
    } -> 
    firewall { "7777 KiwiIRC from ALL":
        proto   => 'tcp',
        port    => '7777',
        action  => 'accept',
    }
}
