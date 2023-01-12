require_relative 'lib/authentication_zero/version'

Gem::Specification.new do |spec|
  spec.name          = "authentication-zero"
  spec.version       = AuthenticationZero::VERSION
  spec.authors       = ["Nixon"]
  spec.email         = ["lazaronixon@hotmail.com"]

  spec.summary       = "An authentication system generator for Rails applications"
  spec.homepage      = "https://github.com/lazaronixon/authentication-zero"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/lazaronixon/authentication-zero"
  spec.metadata["changelog_uri"] = "https://github.com/lazaronixon/authentication-zero/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.post_install_message = <<~EOS
    \n\e[1m\e[31m== Authentication Zero ==\e[0m\e[22m

    It is recommended you keep Authentication Zero as part of your Gemfile even after you have ran the template
    generators so that you can be kept up-to-date regarding important upstream changes and security updates.

    For a full list of changes, go to: \e[4mhttps://github.com/lazaronixon/authentication-zero/blob/master/CHANGELOG.md\e[24m

    Here are the three most recent release notes:

    #{File.read('CHANGELOG.md').scan(/^##.*?(?=^##|\z)/m).first(3).join}
  EOS
end
