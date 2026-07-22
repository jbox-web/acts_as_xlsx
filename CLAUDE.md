# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`acts_as_xlsx` is a Rails gem that adds an `acts_as_xlsx` macro to `ActiveRecord::Base`, letting any model export its records to an Excel spreadsheet via [caxlsx](https://github.com/caxlsx/caxlsx) (the maintained fork of Axlsx). Distributed as a Rails engine; supports Ruby >= 3.2 and Rails >= 7.0.

## Commands

Always go through the project binstubs (they pin the correct Bundler context):

- `bin/rspec` — run the full test suite.
- `bin/rspec spec/acts_as_xlsx/macros_spec.rb` — run one file.
- `bin/rspec spec/acts_as_xlsx/macros_spec.rb:34` — run a single example by line.
- `bin/rubocop` — lint (config in `.rubocop.yml`, `NewCops: enable`).
- `bin/rake` — default task, runs `spec`.
- `bin/guard` — watch-and-rerun specs (Guardfile watches `lib/` and `spec/`).

### Multi-version testing (Appraisal)

CI runs the suite against Rails 7.2 / 8.0 / 8.1 via `gemfiles/*.gemfile`, generated from `Appraisals`. To reproduce locally:

- `bin/appraisal install` — regenerate the gemfiles after editing `Appraisals`.
- `BUNDLE_GEMFILE=gemfiles/rails_8.0.gemfile bin/rspec` — run against a specific Rails version.

The CI matrix is Rubies 3.2–4.0 × the three Rails gemfiles (`.github/workflows/ci.yml`).

## Architecture

The gem is deliberately tiny — four files under `lib/acts_as_xlsx/`:

- `acts_as_xlsx.rb` — entry point. Requires `axlsx` + `zeitwerk`, sets up the Zeitwerk loader, and loads the Rails engine only if `Rails` is defined.
- `engine.rb` — on `active_record` load, `extend`s `ActsAsXlsx::Macros` into `ActiveRecord::Base`, making `acts_as_xlsx` available on every model.
- `macros.rb` — the `acts_as_xlsx(options)` class macro. Declares two `class_attribute`s (`xlsx_i18n`, `xlsx_columns`, defaulting to all `column_names`), then `extend`s `ClassMethods` onto the calling model. This is the only method a model author calls.
- `class_methods.rb` — the real work: `to_xlsx(options)`. Builds an `Axlsx::Package`, adds a worksheet, writes a header row (i18n-translated or humanized column names) and one data row per record.

Data flow: model calls `acts_as_xlsx` → gets `to_xlsx` → `to_xlsx` queries records (`where(...).order(...)`, or an explicit `:data`/`:package`), maps each `columns` entry to a cell value, and returns the package.

Two behaviors worth knowing before touching `to_xlsx`:

- **Chained columns**: a column symbol containing `.` (e.g. `:'comments.first.author.name'`) is split and sent method-by-method down the object graph, short-circuiting to `''` on any nil. Plain symbols are a single `send`. This is what makes association traversal work.
- **Package reuse**: passing `:package` appends a new worksheet to an existing `Axlsx::Package` instead of creating one — this is how multiple models land in a single workbook.

## Tests

Specs run against a full Rails dummy app in `spec/dummy` (models `Post`, `Author`, `Comment` with associations). `spec/spec_helper.rb` boots the dummy app, loads `db/schema.rb`, and seeds fixture records at load time. `spec/config_rspec.rb` holds RSpec config (random order, zero-monkey-patching). Coverage is emitted to `coverage/` via SimpleCov (HTML + JSON) and published to Qlty in CI.
