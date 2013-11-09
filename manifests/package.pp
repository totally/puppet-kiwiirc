class kiwiirc::package{

    $nodejs_v = hiera('nodejs_v','installed')

    if !defined(Class['nodejs']){
        class{ 'nodejs':
            manage_repo => true,
            version     => $nodejs_v,
        }
    }
    if !defined(package['git']){
        package{'git':
            ensure  => installed,
        }
    }

    vcsrepo { '/opt/kiwiirc':
        ensure      => present,
        provider    => git,
        owner       => 'kiwiirc',
        source      => 'https://github.com/prawnsalad/KiwiIRC.git',
        require     => [
            Class['nodejs'],
            Package['git'],
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
    exec {'build kiwiirc':
        command     => './kiwi build',
        cwd         => '/opt/kiwiirc',
        user        => 'kiwiirc',
        onlyif      => 'test -f index.html && test -f kiwi.js',
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
