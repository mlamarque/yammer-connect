# yammer-connect
Yammer Connect to Discourse

# Installation


Run bundle exec rake plugin:install repo=https://github.com/mlamarque/yammer-connect.git in your discourse directory
In development mode, run bundle exec rake assets:clean
In production, recompile your assets: bundle exec rake assets:precompile
Restart Discourse
In discourse go to: "Admin -> Settings -> Yammer connect plugin" and fill "enable mathjax plugin."

PLugin realized in a project to thesocialclient.com