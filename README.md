# Sentient Social

[![Travis](https://img.shields.io/travis/marcdel/sentient_social.svg)](https://travis-ci.org/marcdel/sentient_social)
[![Codecov](https://img.shields.io/codecov/c/github/marcdel/sentient_social.svg)](https://codecov.io/gh/marcdel/sentient_social)
[![Inch](http://inch-ci.org/github/marcdel/sentient_social.svg)](http://inch-ci.org/github/marcdel/sentient_social)

## Pre-commit steps
* `mix credo && mix dialyzer && MIX_ENV=test mix coveralls.html`

## Heroku Setup

* `heroku apps:create sentient-social-staging --buildpack "https://github.com/HashNuke/heroku-buildpack-elixir.git"`
* `heroku buildpacks:add https://github.com/gjaldon/heroku-buildpack-phoenix-static.git`
* `heroku addons:create heroku-postgresql:hobby-dev`
* `heroku config:set POOL_SIZE=18`
* `heroku config:set SECRET_KEY_BASE="$(mix phx.gen.secret)"`

## Twitter Integration Env Vars
`TWITTER_CONSUMER_KEY=`
`TWITTER_CONSUMER_SECRET=`
`CLOAK_KEY=`

## Key generation
* `:crypto.strong_rand_bytes(32) |> Base.encode64()`
