namespace :assets do
  task :precompile do
    puts `bundle exec jekyll build`
  end
end

require 'rake'

desc 'Preview the site with Jekyll'
task :preview do
  sh "jekyll serve --watch --drafts --baseurl '' --config _config.yml,_config-dev.yml"
end

desc 'Search site and print specific deprecation warnings'
task :check do
  sh "jekyll doctor"
end
