# ActsAsXLSX

[![GitHub license](https://img.shields.io/github/license/jbox-web/acts_as_xlsx.svg)](https://github.com/jbox-web/acts_as_xlsx/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/jbox-web/acts_as_xlsx.svg)](https://github.com/jbox-web/acts_as_xlsx/releases/latest)
[![Build Status](https://travis-ci.com/jbox-web/acts_as_xlsx.svg?branch=master)](https://travis-ci.com/jbox-web/acts_as_xlsx)
[![Code Climate](https://codeclimate.com/github/jbox-web/acts_as_xlsx/badges/gpa.svg)](https://codeclimate.com/github/jbox-web/acts_as_xlsx)
[![Test Coverage](https://codeclimate.com/github/jbox-web/acts_as_xlsx/badges/coverage.svg)](https://codeclimate.com/github/jbox-web/acts_as_xlsx/coverage)

ActsAsXLSX is an ActiveRecord plugin for Axlsx. It makes generating Excel spreadsheets from any subclass of ActiveRecord::Base as simple as a couple of lines of code.

## Installation

Put this in your `Gemfile` :

```ruby
git_source(:github){ |repo_name| "https://github.com/#{repo_name}.git" }

gem 'acts_as_xlsx', github: 'jbox-web/acts_as_xlsx', tag: '1.1.0'
```

then run `bundle install`.

## Usage

See the Guides [here](http://axlsx.blog.randym.net/).
