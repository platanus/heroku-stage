# Heroku Stage
[![Build Status](https://travis-ci.org/platanus/heroku-stage.svg?branch=master)](https://travis-ci.org/platanus/heroku-stage)

Get the current deployment stage of your rails app deployed using heroku pipelines.

## Installation

```bash
gem install heroku-stage
```

Or add to your Gemfile:

```ruby
gem "heroku-stage"
```

```bash
bundle install
```

## Why

We've been following the heroku's recommendation on running just one
environment for our apps *productions*. We've moved from having
`staging.rb` and `production.rb` to just have the `production.rb`.
The goal is to promote parity between the two environments. At the end,
we have different **deployment** environments but the same rails one.

This approach makes it difficult when you have to differentiate
some actions based on your deploy environment. We cannot rely on `Rails.env`
anymore because it will always be `production`.

One example is for error monitoring. If we want to know from which
environment the errors are, we need to provide that information somehow.

The idea is to take the same syntax from `Rails.env` but with
`Heroku.stage`

This gem uses the `HEROKU_APP_NAME` environmental variable to get the
current stage on the heroku pipeline.

## The convention

The application name convention is `my-app-<stage>`.

You can manually add the environmental variable `HEROKU_APP_NAME` with the app name

```shell
heroku config:set HEROKU_APP_NAME=<your app>
```

or you can use the [dyno metadata labs](https://devcenter.heroku.com/articles/dyno-metadata)
from heroku which will add the variable on your next deploy.

```shell
heroku labs:enable runtime-dyno-metadata --app <your app>
heroku labs:enable runtime-dyno-metadata --remote production
```

> *Note*: Heroku does not provide the information on what stage the app is running,
> so this gem relies on that convention. I've contacted heroku requesting this information
> but I haven't had any response.

## Usage

To get the current state

```ruby
Heroku.stage # => 'production'
```

You can ask for the production or staging stages

```ruby
Heroku.stage.production? # => true
Heroku.stage.staging? # => false
```

### In development

When using in the *development* rails environment the `Heroku.stage` will
respond with an empty string.

```ruby
Rails.env.development? # true
Heroku.stage # => ''
```

### In review apps

When in a review app you can get the current pull-request

```ruby
Heroku.review_app? # true
Heroku.stage # => pr-43
```

## Testing

To run the specs you need to execute, **in the root path of the gem**, the following command:

```bash
bundle exec guard
```

You need to put **all your tests** in the `/my_gem/spec/` directory.

## Contributing

1. Fork it
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request

## Credits

Thank you [contributors](https://github.com/platanus/heroku-stage/graphs/contributors)!

<img src="http://platan.us/gravatar_with_text.png" alt="Platanus" width="250"/>

Heroku Stage is maintained by [platanus](http://platan.us).

## License

Heroku Stage is © 2016 platanus, spa. It is free software and may be redistributed under the terms specified in the LICENSE file.
