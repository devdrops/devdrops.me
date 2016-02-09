source 'https://rubygems.org'

ruby '2.1.2'
gem 'jekyll'
gem 'kramdown'
gem 'rack-jekyll'
gem 'rake'
gem 'puma'

require 'json'
require 'open-uri'
versions = JSON.parse(open('https://pages.github.com/versions.json').read)
gem 'github-pages', versions['github-pages']
