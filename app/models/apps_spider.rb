# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

# AppsSpider
class AppsSpider < Kimurai::Base
  @name = 'apps_spider'
  @engine = :mechanize

  def self.process(url)
    @start_urls = [url]
    crawl!
  end

  def parse(response, url:, data: {})
    # response.xpath('//*[@id="page"]/div[1]/div[2]/div[2]/div/div[3]/ul/li').each do |category|
    #   browser.click_link category.text, match: :first
      category_url = browser.current_url
    #   response = browser.current_response
      test(response, category_url)
      # binding.pry
      next_btn = response.xpath('//*[@id="page_contents"]/div[3]/a')
      while next_btn.present?
        begin
          browser.click_link next_btn.text
          response = browser.current_response
          new_url = browser.current_url
          test(response, new_url)
        rescue
          next
        end
      end
      # binding.pry
    #   browser.visit url
    # end
  end

  def test(response, url)
    response.css('a.media_list_inner span.media_list_title').each do |app|
      app_scrape(app, url)
    end
  end

  def app_scrape(app, url)
    browser.click_link app.text, match: :first
    response = browser.current_response
    item = {}
    arr = []
    item[:name] = response.xpath('//*[@id="page_contents"]/div[2]/div[2]/h2').text
    item[:description] = response.css('.c-tabs__tab_panels').text
    item[:email] = response.xpath('//*[@id="panel_more_info"]/div[1]/div/div/div/p/a').text
    item[:help_link] = response.xpath('//*[@id="page_contents"]/div[2]/div[1]/div[3]/ul/li[1]/a').text

    response.css('div.top_margin.hide_on_mobile a.tag.charcoal_grey').each do |category|
      arr << category.text
    end
    item[:categories] = arr
    App.where(item).first_or_create
    browser.visit url
  end
end
