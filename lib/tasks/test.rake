# See https://github.com/colszowka/simplecov/issues/235
namespace :test do
  task :coverage do
    require 'simplecov'
    SimpleCov.start 'rails' # feel free to pass block
    Rake::Task["test"].execute
  end
end
