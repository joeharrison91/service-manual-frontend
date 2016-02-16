class ServiceManualTopicPresenter
  ContentOwner = Struct.new(:title, :href)
  attr_reader :content_item, :title, :format, :description, :locale

  def initialize(content_item)
    @content_item = content_item

    @title = content_item["title"]
    @description = content_item["description"]
    @format = content_item["format"]
    @locale = content_item["locale"]
  end

  def breadcrumbs
    parent_breadcrumbs << topic_breadcrumb
  end

  def groups
    linked_items = content_item['links']['linked_items']
    topic_groups = Array(content_item['details']['groups']).map do |group_data|
      ServiceManualTopicPresenter::TopicGroup.new(group_data, linked_items)
    end
    topic_groups.select(&:present?)
  end

  def content_owners
    @content_owners ||= Array(content_item['links']['content_owners']).map do |data|
      ContentOwner.new(data['title'], data['base_path'])
    end
  end

  def phase
    "beta"
  end

private

  def topic_breadcrumb
    { title: title }
  end

  def parent_breadcrumbs
    [
      {
        title: 'Service manual',
        url: '/service-manual'
      }
    ]
  end
end