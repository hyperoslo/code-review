# Code review

[![Code Climate](https://codeclimate.com/github/hyperoslo/code-review.png)](https://codeclimate.com/github/hyperoslo/code-review)

A simple application that selects a random commit for code review.

## Configuration

The application looks to the process' environment variables for its configuration, specifically:

* `ODDS` - A string of the format "x:y" that describes the likelihood that a commit will be selected for review (e.g. "1:25").
* `REVIEWERS` - A comma-separated list of e-mail addresses that code reviews may be addressed to.
* `SMTP_HOST` - A string describing the SMTP host.
* `SMTP_PORT` - A string describing the SMTP port.
* `SMTP_DOMAIN` - A string describing the SMTP domain.
* `SMTP_USERNAME` - A string describing the SMTP username.
* `SMTP_PASSWORD` - A string describing the SMTP password.

## Development

Install the dependencies:

    $ bundle install

Run the tests with either `rake` or `guard`:

    $ bundle exec rake test
    $ bundle exec guard start
