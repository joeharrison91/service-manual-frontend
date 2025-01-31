require 'test_helper'

class ContentItemPresenterTest < ActiveSupport::TestCase
  test "#title" do
    assert_equal "Title", ContentItemPresenter.new("title" => "Title").title
  end

  test "#description" do
    assert_equal "Description", ContentItemPresenter.new("description" => "Description").description
  end

  test "#format" do
    assert_equal "a_format",
                 ContentItemPresenter.new("document_type" => "service_manual_a_format").format
  end

  test "#locale" do
    assert_equal "ar", ContentItemPresenter.new("locale" => "ar").locale
  end

  test "available_translations sorts languages by locale with English first" do
    translated = govuk_content_schema_example('case_study', 'translated')
    locales = ContentItemPresenter.new(translated).available_translations
    assert_equal %w(en ar es), locales.map { |t| t["locale"] }
  end
end
