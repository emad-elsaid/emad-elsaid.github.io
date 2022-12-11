I needed to push my local repository to a remote server.

# On the remote server

- Create the repository `mkdir -p /root/projects/myproj`
- Initialize git `git init .`
- Allow push to update directory `git config --local receive.denyCurrentBranch updateInstead`

# From local repository

- Add remote server as git remote `git remote add server ssh://user@server:/root/prjects/myproj`
- Push to the remote `git push server`