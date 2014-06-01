# Code review

[![Code Climate](https://codeclimate.com/github/hyperoslo/code-review.png)](https://codeclimate.com/github/hyperoslo/code-review)
[![Build Status](https://travis-ci.org/hyperoslo/code-review.png?branch=master)](https://travis-ci.org/hyperoslo/code-review)
[![Coverage Status](https://coveralls.io/repos/hyperoslo/code-review/badge.png?branch=master)](https://coveralls.io/r/hyperoslo/code-review)

We ship a lot of code at Hyper, and we're proud of every bit of it. We built this simple application to
select random commits for review whenever we push code so we can show it off or
ridicule [@espenhogbakk](https://github.com/espenhogbakk) whenever he version controls his passwords.

![Example](https://raw.github.com/hyperoslo/code-review/master/doc/example.png)

## Usage

Create a post-receive hook to hit your code review application and specify the service you're using
in the `service` parameter (e.g. `http://review.example.org?service=github`).

### GitHub

Set the content type for your push-event hook to `application/x-www-form-urlencoded`. Other
content types, such as `application/json`, are currently [not supported](https://github.com/hyperoslo/code-review/issues/24).

On creation of a new webhook, GitHub will [send a ping event](https://developer.github.com/changes/2014-2-10-ping-event-for-webhooks/). This is currently
not handled appropriately, but its failure can be safely ignored.


## Configuration

The application looks to the following environment variables for its configuration:

* `SENDER` - A string describing the sender's name and email address (e.g `Hyper <no-reply@hyper.no>`).
* `ODDS` - A string of the format "x:y" that describes the likelihood that a commit will be selected for review (e.g. `1:25`).
* `REVIEWERS` - A comma-separated list of e-mail addresses that code reviews may be addressed to (e.g. `john@work.com,jane@work.com`).
* `SMTP_HOST` - A string describing the SMTP host.
* `SMTP_PORT` - A string describing the SMTP port.
* `SMTP_DOMAIN` - A string describing the SMTP domain.
* `SMTP_USERNAME` - A string describing the SMTP username.
* `SMTP_PASSWORD` - A string describing the SMTP password.
* `GITLAB_PRIVATE_TOKEN` - A string describing a GitLab private token.
* `GUARANTEED_REVIEW` - A string that will automatically qualify commits for review (defaults to `please review`).

Control over branches with post-receive hook URL params:

* `only_branches` - single branch name or list of comma-separated branches (e.g. http://review.example.org?service=github&only_branches=master,dev). Commits only from listed branches will be selected for code review.
* `except_branches` - works opposite to the previous option (e.g. http://review.example.org?service=github&except_branches=master,dev).

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

## License

Code review is available under the MIT license. See the LICENSE file for more info.
