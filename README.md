# Code review

This is a simple application that selects a random commit for code review.

## Configuration

The application looks to the process' environment variables for its configuration, specifically:

* `ODDS` - A string of the format "x:y" that describes the likelihood that a commit will be selected for review (e.g. "1:25").
* `REVIEWERS` - A comma-separated list of e-mail addresses that code reviews may be addressed to.
* `SENDGRID_USERNAME` - A string describing the SMTP username for SendGrid.
* `SENDGRID_PASSWORD` - A string describing the SMTP password for SendGrid.

## Development

Install the dependencies:

    $ bundle install

Run the tests with either `rake` or `guard`:

    $ bundle exec rake test
    $ bundle exec guard start
