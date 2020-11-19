require 'thor'
require 'thor/group'
require 'git'

class New < Thor
  include Thor::Actions

  def self.source_root
    Pathname.new(__FILE__).dirname.join('..')
  end

  desc 'transformer NAME', 'generates a new transformer named NAME'
  method_option :datastore_kind,
                :type => :string,
                :required => true,
                :desc => "the entity kind of the datastore",
                :aliases => '-k'

  method_option :datastore_namespace,
                :type => :string,
                :default => 'barebone',
                :desc => 'namespace of the datastore',
                :aliases => '-n'

  method_option :service_key,
                :type => :string,
                :required => true,
                :desc => 'key for service discovery',
                :aliases => '-s'

  def transformer(name)
    @name = File.basename(name)
    path = File.expand_path(name)
    @datastore_kind = options[:datastore_kind]
    @datastore_namespace = options[:datastore_namespace]
    @service_key = options[:service_key]
    say "Creating transformer at #{path}"
    directory('templates/transformer', path, recursive: true)
    chmod(path + '/bin/setup.sh', 0o755)
    say 'Bundle install'
    Bundler.with_original_env do
      Dir.chdir path do
        `bundle install`
      end
    end
    chmod(path + '/bin/console', 0o755)

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
  end

  desc 'api NAME', 'generates a new api named NAME'

  method_option :datastore_kind,
                :type => :string,
                :required => true,
                :desc => "the entity kind of the datastore",
                :aliases => '-k'

  method_option :datastore_namespace,
                :type => :string,
                :default => 'barebone',
                :desc => 'namespace of the datastore',
                :aliases => '-n'

  def api(name)
    @name = File.basename(name)
    path = File.expand_path(name)
    @datastore_kind = options[:datastore_kind]
    @datastore_namespace = options[:datastore_namespace]

    say "Creating api at #{name}"
    directory('templates/transformer', path, recursive: true)
    chmod(path + '/bin/setup.sh', 0o755)
    say 'Bundle install'
    Bundler.with_original_env do
      Dir.chdir path do
        `bundle install`
      end
    end
    chmod(path + '/bin/console', 0o755)

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
end
