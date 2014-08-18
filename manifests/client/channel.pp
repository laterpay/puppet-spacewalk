define spacewalk::client::channel(
  $username        = 'username',
  $password        = 'password',
  $channel         = $title,
  $ensure          = 'present',
  $channel_key_uri = '',
  $channel_key_id  = '',
  ) {

  if $channel_key_uri == '' and $channel_key_id != '' {
    fail("if you specify a channel_key_id, a channel_key is also required!")
  }

  if $channel_key_id == '' and $channel_key_uri != '' {
    fail("if you specify a channel_key_uri, a channel_key_id is also required!")
  }

  if $ensure == 'present' {
    $channel_option = '-a'

    exec { $title:
      command => "spacewalk-channel ${channel_option} -c ${channel} -u ${username} -p ${password}",
      path    => ['/usr/bin', '/usr/sbin', '/bin', ],
      unless  => "yum -C repolist enabled 2>/dev/null | grep -qw ${channel}",
    }

    if $channel_key_id != '' and $channel_key_uri != '' {
      exec { "${$title}_channel_key":
        command => "rpm --import ${channel_key_uri}",
        path    => ['/bin', '/usr/bin', ],
        unless  => "rpm -qa --nosignature --nodigest --qf '%{VERSION}\n' gpg-pubkey|grep -q ${channel_key_id}",
      }

      Exec[$title] -> Exec["${title}_channel_key"]
    }
  }
  elsif $ensure == 'absent' {
    $channel_option = '-r'

    exec { $title:
      command => "spacewalk-channel ${channel_option} -c ${channel} -u ${username} -p ${password}",
      path    => ['/usr/bin', '/usr/sbin', '/bin', ],
      onlyif  => "yum -C repolist enabled 2>/dev/null | grep -qw ${channel}",
    }

    if $channel_key_id != '' and $channel_key_uri != '' {
      exec { "${$title}_channel_key_delete":
        command => "rpm -e --allmatches gpg-pubkey-${channel_key_id}",
        path    => ['/bin', '/usr/bin', ],
        onlyif  => "rpm -qa --nosignature --nodigest --qf '%{VERSION}\n' gpg-pubkey|grep -q ${channel_key_id}",
      }

      Exec[$title] -> Exec["${title}_channel_key_delete"]
    }
  }
  else {
    fail("Unsupported value for option ensure: $ensure, has to be 'present' or 'absent'")
  }
}
