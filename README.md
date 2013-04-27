# Code review

[![Code Climate](https://codeclimate.com/github/hyperoslo/code-review.png)](https://codeclimate.com/github/hyperoslo/code-review)
[![Build Status](https://travis-ci.org/hyperoslo/code-review.png?branch=master)](https://travis-ci.org/hyperoslo/code-review)
[![Coverage Status](https://coveralls.io/repos/hyperoslo/code-review/badge.png?branch=master)](https://coveralls.io/r/hyperoslo/code-review)

A simple Sinatra application selects random commits for review when you push to [GitLab](http://gitlab.org/).

## Configuration

The application looks to the following environment variables for its configuration:

* `ODDS` - A string of the format "x:y" that describes the likelihood that a commit will be selected for review (e.g. `1:25`).
* `REVIEWERS` - A comma-separated list of e-mail address pairs (first and second in pair separated by a colon) that code reviews
  may be addressed to. For example `john@home.com:john@work.com,jane@home.com:jane@work.com`.
* `SMTP_HOST` - A string describing the SMTP host.
* `SMTP_PORT` - A string describing the SMTP port.
* `SMTP_DOMAIN` - A string describing the SMTP domain.
* `SMTP_USERNAME` - A string describing the SMTP username.
* `SMTP_PASSWORD` - A string describing the SMTP password.

## Development

Install the dependencies:

    $ bundle install

Run the tests:

    $ bundle exec rake test

Run the server:

    $ bundle exec rackup

## Credits

Hyper made this. We're a digital communications agency with a passion for good code,
and if you're using this application we probably want to hire you.
