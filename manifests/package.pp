class kiwiirc::package{

    include nodejs

    vcsrepo { '/opt/kiwiirc':
        ensure      => present,
        provider    => git,
        owner       => 'kiwiirc',
        source      => 'https://github.com/prawnsalad/KiwiIRC.git',
        require     => [
            Class['nodejs'],
            Class['git'],
            Class['kiwiirc::user']
        ],
    } -> 

    # 'npm install' writes to /.npm
    #  - workaround: link /.npm -> /opt/kiwiirc/.npm
    file {'/opt/kiwiirc/.npm': 
        ensure      => directory,
        owner       => 'kiwiirc',
        group       => 'kiwiirc',
    } -> 
    file { '/.npm':
        ensure      => link,
        target      => '/opt/kiwiirc/.npm',
    } -> 
    exec {'npm install kiwiirc':
        command     => 'npm install',
        cwd         => '/opt/kiwiirc',
        user        => 'kiwiirc',
        onlyif      => 'test $(ls -1 /opt/kiwiirc/.npm | wc -l) -lt 1',
        logoutput   => true,
    } -> 
    # startup script
    file {'/etc/init/kiwiirc.conf':
        ensure      => file,
        owner       => root, 
        group       => root,
        source      => 'puppet:///modules/kiwiirc/upstart',
    }

}
