# frozen_string_literal: true

module ActsAsXlsx
  class Engine < ::Rails::Engine

    initializer 'acts_as_xlsx.initialize' do
      ActiveSupport.on_load(:active_record) do
        extend ActsAsXlsx::Macros
      end
    end

  end
end
