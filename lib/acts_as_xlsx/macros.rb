# frozen_string_literal: true

module ActsAsXlsx
  module Macros

    def acts_as_xlsx(options = {})
      cattr_accessor :xlsx_i18n, :xlsx_columns
      self.xlsx_i18n = options.delete(:i18n) || false
      self.xlsx_columns = options.delete(:columns)
      extend ActsAsXlsx::ClassMethods
    end

  end
end
