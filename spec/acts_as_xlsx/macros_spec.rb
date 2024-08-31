# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActsAsXlsx::Macros do

  describe 'to_xlsx_with_package' do
    let(:p) { Post.to_xlsx }

    it 'returns xslx data' do
      Post.to_xlsx package: p, name: 'another posts'
      expect(p.workbook.worksheets.size).to eq 2
    end
  end

  describe 'to_xlsx_with_name' do
    let(:p) { Post.to_xlsx name: 'bob' }

    it 'returns xslx data' do
      expect(p.workbook.worksheets.first.name).to eq 'bob'
    end
  end

  describe 'xlsx_columns' do
    it 'returns xslx data' do
      expect(Post.xlsx_columns).to eq Post.column_names.map(&:to_sym)
    end
  end

  describe 'to_xslx_vanilla' do
    let(:p) { Post.to_xlsx }

    it 'returns xslx data' do
      expect(p.workbook.worksheets.first.rows.first.cells.first.value).to eq 'Id'
      expect(p.workbook.worksheets.first.rows.last.cells.first.value).to eq 2
    end
  end

  describe 'to_xslx_with_provided_data' do
    let(:p) { Post.to_xlsx data: Post.where(title: 'This is the first post').all }

    it 'returns xslx data' do
      expect(p.workbook.worksheets.first.rows.first.cells.first.value).to eq 'Id'
      expect(p.workbook.worksheets.first.rows.last.cells.first.value).to eq 1
    end
  end

  describe 'columns' do
    let(:p) { Post.to_xlsx columns: %i[name title content votes] }
    let(:sheet) { p.workbook.worksheets.first }

    it 'returns xslx data' do
      expect(sheet.rows.first.cells.size).to eq Post.xlsx_columns.size - 3
      expect(sheet.rows.first.cells.first.value).to eq 'Name'
      expect(sheet.rows.last.cells.last.value).to eq 7
    end
  end

  describe 'method_in_columns' do
    let(:p) { Post.to_xlsx columns: %i[name votes content ranking] }
    let(:sheet) { p.workbook.worksheets.first }

    it 'returns xslx data' do
      expect(sheet.rows.first.cells.first.value).to eq 'Name'
      expect(sheet.rows.last.cells.last.value).to eq Post.last.ranking
    end
  end

  describe 'chained_method' do
    let(:p) { Post.to_xlsx columns: %i[name votes content ranking comments.last.content comments.first.author.name] }
    let(:sheet) { p.workbook.worksheets.first }

    it 'returns xslx data' do
      expect(sheet.rows.first.cells.first.value).to eq 'Name'
      expect(sheet.rows.last.cells.last.value).to eq Post.last.comments.last.author.name
    end
  end
end
