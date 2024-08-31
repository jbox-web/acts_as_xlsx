# frozen_string_literal: true

module ActsAsXlsx
  module ClassMethods

    # Maps the AR class to an Axlsx package
    # options are passed into AR find
    # @param [Array, Array] columns as an array of symbols or a symbol that defines the attributes or methods to render in the sheet.
    # @option options [Integer] header_style to apply to the first row of field names
    # @option options [Array, Symbol] types an array of Axlsx types for each cell in data rows or a single type that will be applied to all types.
    # @option options [Integer, Array] style The style to pass to Worksheet#add_row
    # @option options [String] i18n The path to i18n attributes. (usually activerecord.attributes)
    # @option options [Package] package An Axlsx::Package. When this is provided the output will be added to the package as a new sheet.
    # @option options [String] name This will be used to name the worksheet added to the package.
    # If it is not provided the name of the table name will be humanized when i18n is not specified or the I18n.t for the table name.
    # @see Worksheet#add_row
    def to_xlsx(options = {}) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
      row_style = options.delete(:style)
      header_style = options.delete(:header_style) || row_style
      types = [options.delete(:types) || []].flatten

      i18n = options.delete(:i18n) || xlsx_i18n
      columns = options.delete(:columns) || xlsx_columns

      p = options.delete(:package) || Axlsx::Package.new
      row_style = p.workbook.styles.add_style(row_style) unless row_style.nil?
      header_style = p.workbook.styles.add_style(header_style) unless header_style.nil?
      i18n = 'activerecord.attributes' if xlsx_i18n == true
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
              v = r
              c.to_s.split('.').each { |method| v = v.nil? ? '' : v.send(method) }
              v
            else
              r.send(c)
            end
          end
          sheet.add_row(row_data, style: row_style, types: types)
        end
      end
      p
    end

  end
end
