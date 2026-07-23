# frozen_string_literal: true

module ActsAsXlsx
  module Macros

    # Enables xlsx export on the calling ActiveRecord model.
    #
    # Stores the export defaults as class attributes and mixes in ClassMethods, which provides `to_xlsx`.
    # Both defaults can be overridden per call on `to_xlsx`.
    #
    # @param [Hash] options
    # @option options [Boolean, String] i18n Default i18n behaviour for exports (see {ClassMethods#to_xlsx}). Defaults to false.
    # @option options [Array<Symbol>] columns Default columns to export. Defaults to every column name as a symbol.
    # @return [void]
    def acts_as_xlsx(options = {})
      class_attribute :xlsx_i18n, :xlsx_columns
      self.xlsx_i18n = options.delete(:i18n) || false
      self.xlsx_columns = options.delete(:columns) { column_names.map(&:to_sym) }
      extend ActsAsXlsx::ClassMethods
    end

  end
end
