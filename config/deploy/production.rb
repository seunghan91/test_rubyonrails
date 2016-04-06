#수정됨


server '192.168.33.10', user: 'deployer', roles: %w{app db web}
set :nginx_server_name, 'techblog.rorlab.org'
set :stage, :staging
