# frozen_string_literal: true

module ActsAsXlsx
  module ClassMethods

    # Renders the class's records into an Axlsx worksheet and returns the enclosing package.
    #
    # With no :data option the records are fetched via `where(options[:where]).order(options[:order])`,
    # so :where and :order are forwarded to ActiveRecord untouched.
    #
    # @param [Hash] options
    # @option options [Array<Symbol>] columns The attributes or methods to render, one per column.
    #   A symbol containing '.' (e.g. :'comments.first.author.name') is walked down the object graph,
    #   short-circuiting to '' on the first nil link. Defaults to the class-level xlsx_columns.
    # @option options [Array<Object>] data Explicit records to render, bypassing the AR query above.
    # @option options [Hash, String] where Conditions forwarded to `where` when :data is absent.
    # @option options [Symbol, Hash, String] order Ordering forwarded to `order` when :data is absent.
    # @option options [Hash, Symbol] style Style applied to every data row (passed to Axlsx::Styles#add_style).
    # @option options [Hash, Symbol] header_style Style applied to the header row. Defaults to :style when omitted.
    # @option options [Array<Symbol>, Symbol] types An Axlsx cell type per column, or a single type applied to all.
    # @option options [Boolean, String] i18n When true, resolves labels under 'activerecord.attributes';
    #   a String is used as the base translation path. Overrides the class-level xlsx_i18n for this call.
    # @option options [Axlsx::Package] package An existing package to append the worksheet to, enabling
    #   multiple models in one workbook. A fresh package is created when omitted.
    # @option options [String] name The worksheet name. Defaults to the i18n-translated or humanized table name.
    # @return [Axlsx::Package] the package containing the rendered worksheet (unchanged if the data set is empty).
    # @see Axlsx::Worksheet#add_row
    def to_xlsx(options = {}) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
      # A single type (Symbol) is applied to every cell; an Array is applied by index.
      # Passing it through untouched preserves that Axlsx semantics.
      types = options.delete(:types)

      # options.key? so an explicit `i18n: false` can override a class-level `i18n: true`.
      i18n = options.key?(:i18n) ? options.delete(:i18n) : xlsx_i18n
      columns = options.delete(:columns) || xlsx_columns

      p = options.delete(:package) || Axlsx::Package.new
      row_style = options.delete(:style)
      row_style = p.workbook.styles.add_style(row_style) unless row_style.nil?
      header_style = options.delete(:header_style)
      # Reuse the already-registered row_style index when no header_style is given, to avoid a duplicate style.
      header_style = header_style.nil? ? row_style : p.workbook.styles.add_style(header_style)

      i18n = 'activerecord.attributes' if i18n == true
      sheet_name = options.delete(:name) || (i18n ? I18n.t("#{i18n}.#{table_name.underscore}") : table_name.humanize)
      data = options.delete(:data) || where(options[:where]).order(options[:order]).to_a
      data.compact! if data.respond_to?(:compact!)
      data.flatten! if data.respond_to?(:flatten!)

      return p if data.empty?

      p.workbook.add_worksheet(name: sheet_name) do |sheet|
        col_labels =
          if i18n
            columns.map { |c| I18n.t("#{i18n}.#{name.underscore}.#{c}") }
          else
            columns.map { |c| c.to_s.humanize }
          end

        sheet.add_row(col_labels, style: header_style)

        data.each do |r|
          row_data = columns.map do |c|
            if c.to_s.include?('.')
              # Walk the chain, short-circuiting to nil on the first nil link (no further sends).
              v = c.to_s.split('.').reduce(r) { |acc, method| acc&.public_send(method) }
              v.nil? ? '' : v
            else
              r.public_send(c)
            end
          end
          sheet.add_row(row_data, style: row_style, types: types)
        end
      end
      p
    end

  end
end
