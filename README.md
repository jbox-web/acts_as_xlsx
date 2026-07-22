# ActsAsXLSX

[![GitHub license](https://img.shields.io/github/license/jbox-web/acts_as_xlsx.svg)](https://github.com/jbox-web/acts_as_xlsx/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/jbox-web/acts_as_xlsx.svg)](https://github.com/jbox-web/acts_as_xlsx/releases/latest)
[![CI](https://github.com/jbox-web/acts_as_xlsx/workflows/CI/badge.svg)](https://github.com/jbox-web/acts_as_xlsx/actions)
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

Declare `acts_as_xlsx` in any model. This adds a `to_xlsx` class method that
returns an [`Axlsx::Package`](https://github.com/caxlsx/caxlsx).

```ruby
class Post < ApplicationRecord
  acts_as_xlsx
end

# Build the spreadsheet and write it to disk
Post.to_xlsx.serialize('posts.xlsx')
```

### `acts_as_xlsx` options

| Option    | Description |
|-----------|-------------|
| `:columns` | Array of attributes/methods to export (defaults to all `column_names`). |
| `:i18n`    | `true` to translate labels via `activerecord.attributes`, or a custom i18n path. Defaults to `false`. |

```ruby
class Post < ApplicationRecord
  acts_as_xlsx i18n: true, columns: %i[name title votes]
end
```

### `to_xlsx` options

Every option can be overridden per call. `:columns` and `:i18n` behave as above.

| Option         | Description |
|----------------|-------------|
| `:columns`     | Override the exported columns. Supports method chains such as `:'comments.first.author.name'` (a nil link yields an empty cell). |
| `:i18n`        | Override the i18n behaviour for this call. |
| `:name`        | Worksheet name (max 31 characters). Defaults to the humanized/translated table name. |
| `:data`        | An explicit collection to export instead of querying the table. |
| `:where`       | Conditions passed to `where` when `:data` is not given. |
| `:order`       | Ordering passed to `order` when `:data` is not given. |
| `:types`       | A single Axlsx type symbol applied to every cell, or an Array of types applied by column index. |
| `:style`       | Style hash applied to every data row (passed to `Axlsx::Styles#add_style`). |
| `:header_style`| Style hash for the header row. Defaults to `:style`. |
| `:package`     | An existing `Axlsx::Package`; the export is added as a new worksheet, letting you build a multi-sheet workbook. |

```ruby
package = Post.to_xlsx(name: 'Posts')
Comment.to_xlsx(package: package, name: 'Comments')
package.serialize('blog.xlsx')
```
