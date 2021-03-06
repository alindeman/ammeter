require 'aruba/cucumber'

Before do
  @aruba_timeout_seconds = 10
end

def aruba_path(file_or_dir, source_foldername)
  File.expand_path("../../../#{file_or_dir.sub(source_foldername,'aruba')}", __FILE__)
end

def example_app_path(file_or_dir)
  File.expand_path("../../../#{file_or_dir}", __FILE__)
end

def write_symlink(file_or_dir, source_foldername)
  source = example_app_path(file_or_dir)
  target = aruba_path(file_or_dir, source_foldername)
  system "ln -s #{source} #{target}"
end

def copy_to_aruba_from(gem_or_app_name)
  steps %Q{
    Given a directory named "spec"
  }

  Dir["tmp/#{gem_or_app_name}/*"].each do |file_or_dir|
    if !(file_or_dir =~ /\/spec$/)
      write_symlink(file_or_dir, gem_or_app_name)
    end
  end
  write_symlink("tmp/#{gem_or_app_name}/spec/spec_helper.rb", gem_or_app_name)
end

Before '@example_app' do
  copy_to_aruba_from('example_app')
end

Before '@railties_gem' do
  copy_to_aruba_from('my_railties_gem')
end

Before '@rails_gem' do
  copy_to_aruba_from('my_rails_gem')
end
