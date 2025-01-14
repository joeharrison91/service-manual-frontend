require 'test_helper'

class ServiceStandardPresenterTest < ActiveSupport::TestCase
  test "#points gets points from the details" do
    points = presented_standard.points

    assert points.any? { |point_hash| point_hash.title == "1. Understand user needs" }
    assert points.any? { |point_hash| point_hash.title == "2. Do ongoing user research" }
  end

  test "#points returns points ordered numerically" do
    content_item_hash = {
      "links" => {
        "children" => [
          { "title" => "3. Title" },
          { "title" => "1. Title" },
          { "title" => "9. Title" },
          { "title" => "10. Title" },
          { "title" => "5. Title" },
          { "title" => "6. Title" },
          { "title" => "2. Title" },
          { "title" => "4. Title" },
          { "title" => "7. Title" },
          { "title" => "11. Title" },
          { "title" => "8. Title" },
        ]
      }
    }

    points_titles =
      ServiceStandardPresenter.new(content_item_hash).points.map(&:title)

    assert_equal points_titles, [
      "1. Title",
      "2. Title",
      "3. Title",
      "4. Title",
      "5. Title",
      "6. Title",
      "7. Title",
      "8. Title",
      "9. Title",
      "10. Title",
      "11. Title",
    ]
  end

  test "#points is empty if there aren't any points in the content item" do
    assert ServiceStandardPresenter.new({}).points.empty?
  end

  test "#breadcrumbs contains a link to the service manual root" do
    content_item_hash = {
      "title" => "Service Standard"
    }

    assert ServiceStandardPresenter.new(content_item_hash).breadcrumbs,
           [
             { title: "Service manual", url: "/service-manual" },
             { title: "Service Standard" },
           ]
  end

  test '#email_alert_signup returns a link to the email alert signup' do
    assert_equal "/service-manual/service-standard/email-signup",
                 presented_standard.email_alert_signup_link
  end

  test '#email_alert_signup does not error if no signup exists' do
    assert_nil presented_standard(links: { email_alert_signup: [] }).email_alert_signup_link
  end

  test "#poster_url returns a link to the service standard poster" do
    assert_equal "http://example.com/service-standard-poster.pdf", presented_standard.poster_url
  end

private

  def presented_standard(overriden_attributes = {})
    example = GovukContentSchemaTestHelpers::Examples.new.get(
      'service_manual_service_standard',
      'service_manual_service_standard'
    )

    example_with_overrides = JSON.parse(example)
      .merge(overriden_attributes.with_indifferent_access)

    ServiceStandardPresenter.new(example_with_overrides)
  end
end
