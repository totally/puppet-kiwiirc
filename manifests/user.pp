class kiwiirc::user { 
    user { 'kiwiirc':
        ensure  => present,
        uid     => '5555',
        gid     => '5555',
        require => Group['kiwiirc'],
        home    => '/opt/kiwiirc',
    }
    group {'kiwiirc':
        ensure  => present,
        gid     => 5555,
    }

}
