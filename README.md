<p align="center">
  <img width="200" alt="Neptuno Logo" src="docs/logo_shadow.svg">
</p>

# Neptuno

Neptuno is an "environment as code" framework; which aims to be opinionated enough to get you going fast, and customizable enough to run just the way you work.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'neptuno'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install neptuno

## Usage

Once installed you can run neptuno by its executable to see the options available.

    $ bundle exec neptuno

If you are using a version manager for Ruby you may want to setup an alias to the executable shim so that you can run Neptuno even when your manager switches ruby versions.
Notice that you may have to change the path depending on which Ruby version you use globally:

### rbenv
Add this to your ~/.zshrc
```bash
alias uno='/Users/$USER/.rvm/gems/ruby-3.0.2/bin/neptuno'
```

### asdf
Add this to your ~/.zshrc
```bash
alias uno='/Users/$USER/.asdf/installs/ruby/3.0.2/bin/neptuno'
```

## Ubuntu Users
Add this to your neptuno.yml
```yml
docker_delimiter: "_"
```
The path you need for rbenv and asdf may be different.

## docker-compose\docker compose workaround

Create docker-compole link and add add it to PATH
with content

```bash
# /bin/docker-compose

docker compose --compatibility "$@"
```

```bash
mkdir -p ~/.local/bin
cat > ~/.local/bin/docker-compose << EOF
# /bin/docker-compose

docker compose --compatibility "\$@"
EOF
chmod +x ~/.local/bin/docker-compose
```

Add this to your ~/.zshrc

```bash
export PATH=$PATH:"$HOME/.local/bin"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/apptegy/neptuno. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/neptuno/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [Apache 2.0](https://opensource.org/licenses/Apache-2.0).

## Code of Conduct

Everyone interacting in the Neptuno project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/neptuno/blob/master/CODE_OF_CONDUCT.md).
