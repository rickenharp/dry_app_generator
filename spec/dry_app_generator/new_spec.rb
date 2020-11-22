require 'spec_helper'
require 'dry_app_generator/command'
require 'tmpdir'
require 'open3'

RSpec.describe DryAppGenerator::Command do
  it 'can be instantiated' do
    expect { described_class.new }.to_not raise_error
  end

  describe '#new' do
    
    around do |example|
      original_stderr = $stderr
      original_stdout = $stdout
      $stderr = File.open(File::NULL, "w")
      $stdout = File.open(File::NULL, "w")
      example.run
      $stderr = original_stderr
      $stdout = original_stdout
    end
  
    it 'creates a working app' do
      Dir.mktmpdir do |tmpdir|
        puts tmpdir
        app_dir = tmpdir + '/foobar'
        command = described_class.new
        ENV['GIT_AUTHOR_NAME'] = 'My Name'
        ENV['GIT_AUTHOR_EMAIL'] = 'me@example.com'
        expect { command.new(app_dir) }.to output.to_stdout
        
        Bundler.with_original_env do
          Dir.chdir app_dir do
            out, ps = Open3.capture2e("ruby app.rb")
            expect(ps).to be_success, out
          end
        end
      end
    end
  end
end