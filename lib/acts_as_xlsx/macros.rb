# frozen_string_literal: true

module ActsAsXlsx
  module Macros

    def acts_as_xlsx(options = {})
      class_attribute :xlsx_i18n, :xlsx_columns
      self.xlsx_i18n = options.delete(:i18n) || false
      self.xlsx_columns = options.delete(:columns) { column_names.map(&:to_sym) }
      extend ActsAsXlsx::ClassMethods
    end

  end
end
