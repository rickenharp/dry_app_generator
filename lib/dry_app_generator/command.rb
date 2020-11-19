require 'thor'
require 'pathname'
require 'git'
require 'bundler'
require "dry/inflector"

module DryAppGenerator
  class Command < Thor
    include Thor::Actions

    def self.source_root
      Pathname.new(__FILE__).dirname.join('../..')
    end

    desc 'new NAME', 'create a new app named NAME'
    
    def new(name)
      inflector = Dry::Inflector.new
      @name = name
      @base_name = File.basename(name)
      @module_name = inflector.camelize(@base_name)
      path = File.expand_path(name)
      say "Creating application at #{path}"
      directory('templates', path, recursive: true)
      say 'Bundle install'
      Bundler.with_original_env do
        Dir.chdir path do
          `bundle install`
        end
      end
      chmod(path + '/bin/console', 0o755)
      chmod(path + '/bin/setup.sh', 0o755)
      inside(path) do
        g = Git.init
        begin
          g.log.size
        rescue Git::GitExecuteError
          say 'Setting up git repository'
          g.add(all: true)
          g.commit('initial skeleton')
        end
      end
    end

    no_commands do
      def name
        @name
      end

      def base_name
        @base_name
      end
    end
  end
end