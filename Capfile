load 'deploy'
default_environment["LC_CTYPE"] = "en_US.UTF-8"

set :application, "verbql"
set :deploy_via, :remote_cache
set :deploy_to, "/www/#{application}"
set :keep_releases, 3
set :repository, "http://svn.datadevelopment.net/actionverb/#{application}"
set :user, "root"

role :app, "m_0_0.actionverb.com"

namespace :deploy do
	task :after_update_code do
  	# nothing
	end
	task :finalize_update do
		# nothing
	end
	task :migrate do
		# nothing
	end
	task :restart do
		# nothing
	end
	task :rollout do
  	run "cd /www/verbql/current && make && make install && /etc/init.d/httpd restart"
	end
	task :start do
		# nothing
	end
	task :stop do
		# nothing
	end
end