require 'test_helper'

class ServiceStandardTest < ActionDispatch::IntegrationTest
  test "service standard page has a title, summary and intro" do
    setup_and_visit_example(
      'service_manual_service_standard',
      'service_manual_service_standard',
      title: "Service Standard",
      description: "The Service Standard is a set of 14 criteria.",
      details: {
        body: "All public facing transactional services must meet the standard."
      }
    )

    assert page.has_css?(".page-header__title", text: "Service Standard"), "No title found"
    assert page.has_css?(".page-header__summary", text: "The Service Standard is a set of 14 criteria"), "No description found"
    assert page.has_css?(".page-header__intro", text: "All public facing transactional services must meet the standard."), "No body found"
  end

  test "service standard page has points" do
    setup_and_visit_example('service_manual_service_standard', 'service_manual_service_standard')

    assert_equal 3, points.length

    within(points[0]) do
      assert page.has_content?("1. Understand user needs"), "Point not found"
      assert page.has_content?(/Research to develop a deep knowledge/), "Description not found"
      assert page.has_link?("Read more about point 1", href: "/service-manual/service-standard/understand-user-needs"), "Link not found"
    end

    within(points[1]) do
      assert page.has_content?("2. Do ongoing user research"), "Point not found"
      assert page.has_content?(/Put a plan in place/), "Description not found"
      assert page.has_link?("Read more about point 2", href: "/service-manual/service-standard/do-ongoing-user-research"), "Link not found"
    end

    within(points[2]) do
      assert page.has_content?("3. Have a multidisciplinary team"), "Point not found"
      assert page.has_content?(/Put in place a sustainable multidisciplinary/), "Description not found"
      assert page.has_link?("Read more about point 3", href: "/service-manual/service-standard/have-a-multidisciplinary-team"), "Link not found"
    end
  end

  test "each point has an anchor tag so that they can be linked to externally" do
    setup_and_visit_example('service_manual_service_standard', 'service_manual_service_standard')

    within('div[id="criterion-1"]') do
      assert page.has_content?("1. Understand user needs"), "Anchor is incorrect"
    end

    within('div[id="criterion-2"]') do
      assert page.has_content?("2. Do ongoing user research"), "Anchor is incorrect"
    end

    within('div[id="criterion-3"]') do
      assert page.has_content?("3. Have a multidisciplinary team"), "Anchor is incorrect"
    end
  end

  test "it includes a link to subscribe for email alerts" do
    setup_and_visit_example('service_manual_service_standard', 'service_manual_service_standard')

    assert page.has_link?("email",
                          href: "/service-manual/service-standard/email-signup")
  end

  def points
    find_all('.service-standard-point')
  end
end
