require 'test_helper'

class GuideTest < ActionDispatch::IntegrationTest
  test "shows the time it was saved if it hasn't been published yet" do
    now = "2015-10-10T09:00:00+00:00"
    last_saved_at = "2015-10-10T08:55:00+00:00"

    travel_to(now) do
      example = simulate_example_as_first_edition_on_draft_stack(
        govuk_content_schema_example(
          'service_manual_guide',
          'service_manual_guide',
          updated_at: last_saved_at
        )
      )
      base_path = example.fetch('base_path')
      content_store_has_item(base_path, example)
      visit base_path

      within('.metadata') do
        assert page.has_content?('5 minutes ago')
      end
    end
  end

  test "shows the time it was published if it has been published" do
    travel_to Time.zone.local(2015, 10, 10, 0, 0, 0) do
      setup_and_visit_example('service_manual_guide', 'service_manual_guide')

      within('.metadata') do
        assert page.has_content?('about 16 hours ago')
      end
    end
  end

  test "service manual guide shows content owners" do
    setup_and_visit_example('service_manual_guide', 'service_manual_guide')

    within('.metadata') do
      assert page.has_link?('Agile delivery community')
    end
  end

  test "the breadcrumb contains the topic" do
    setup_and_visit_example('service_manual_guide', 'service_manual_guide')

    within('.gem-c-breadcrumbs') do
      assert page.has_link?('Service manual')
      assert page.has_link?('Agile')
    end
  end

  test "service manual guide does not show published by" do
    setup_and_visit_example('service_manual_guide', 'service_manual_guide_community')

    within('.metadata') do
      refute page.has_content?('Published by')
    end
  end

  test "displays the description for a point" do
    setup_and_visit_example('service_manual_guide', 'point_page')

    within('.page-header__summary') do
      assert page.has_content?('Research to develop a deep knowledge of who the service users are')
    end
  end

  test "does not display the description for a normal guide" do
    setup_and_visit_example('service_manual_guide', 'service_manual_guide')

    refute page.has_css?('.page-header__summary')
  end

  test "displays a link to give feedback" do
    setup_and_visit_example('service_manual_guide', 'service_manual_guide')

    assert page.has_link?('Give feedback about this page')
  end

  test 'displays the published date of the most recent change' do
    setup_and_visit_example('service_manual_guide', 'service_manual_guide')

    within('.change-history') do
      assert page.has_content? 'Last update: 9 October 2015'
    end
  end

  test 'displays the most recent change history for a guide' do
    setup_and_visit_example('service_manual_guide', 'service_manual_guide')

    within('.change-history') do
      assert page.has_content? 'This is our latest change'
    end
  end

  test 'displays the change history for a guide' do
    setup_and_visit_example('service_manual_guide', 'service_manual_guide')

    within('.change-history__past') do
      assert page.has_content? 'This is another change'
      assert page.has_content? 'Guidance first published'
    end
  end

  test 'omits the previous history if there is only one change' do
    setup_and_visit_example('service_manual_guide', 'service_manual_guide',
                            "details" => {
                              "change_history" => [
                                {
                                  "public_timestamp" => "2015-09-01T08:17:10+00:00",
                                  "note" => "Guidance first published"
                                }
                              ]
                            })

    refute page.has_content? 'Show all page updates'
    refute page.has_css? '.change-history__past'
  end

  test 'omits the latest change and previous change if the guide has no history' do
    setup_and_visit_example('service_manual_guide', 'service_manual_guide',
                            "details" => {
                              "change_history" => []
                            })

    refute page.has_content? 'Last update:'
    refute page.has_content? 'Show all page updates'
    refute page.has_css? '.change-history__past'
  end
end
