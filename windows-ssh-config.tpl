add-content -path c:/Users/Admin/.ssh/config -value @'

    Host ${hostname}
      hostname     ${hostname}
      User         ${user}
      IdentityFile ${identityfile}
'@