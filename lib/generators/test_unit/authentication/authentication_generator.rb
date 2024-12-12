require "rails/generators/test_unit"

module TestUnit # :nodoc:
  class AuthenticationGenerator < Rails::Generators::Base # :nodoc:
    source_root File.expand_path("templates", __dir__)

    class_option :api,           type: :boolean, desc: "Generates API authentication"

    def create_fixture_file
      template "test/fixtures/users.yml"
    end

    def create_test_files
      directory "test/controllers/#{format}", "test/controllers"
      directory "test/mailers/", "test/mailers"
      template  "test/test_helper.rb", "test/test_helper.rb", force: true
    end

    private

    def format
      options.api? ? "api" : "html"
    end
  end
end