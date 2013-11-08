class kiwiirc::service {
    service {'kiwiirc':
        ensure  => running,
        require => [
            Class['kiwiirc::config'],
            Class['kiwiirc::package'],
        ],
    }
}
