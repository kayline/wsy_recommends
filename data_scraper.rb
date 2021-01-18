# Require the gems
require 'capybara'
require 'selenium/webdriver'
require 'byebug'
require 'csv'

# Configure Poltergeist to not blow up on websites with js errors aka every website with js
# See more options at https://github.com/teampoltergeist/poltergeist#customization
options = Selenium::WebDriver::Chrome::Options.new
options.add_preference(:download, prompt_for_download: false,
                       default_directory: '/tmp/downloads')

options.add_preference(:browser, set_download_behavior: { behavior: 'allow' })

Capybara.register_driver :headless_chrome do |app|
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1280,800')

  driver = Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)

  ### Allow file downloads in Google Chrome when headless!!!
  ### https://bugs.chromium.org/p/chromium/issues/detail?id=696481#c89
  bridge = driver.browser.send(:bridge)

  path = '/session/:session_id/chromium/send_command'
  path[':session_id'] = bridge.session_id

  bridge.http.call(:post, path, cmd: 'Page.setDownloadBehavior',
                   params: {
                     behavior: 'allow',
                     downloadPath: '/tmp/downloads'
                   })
  ###

  driver
end

# Configure Capybara to use Poltergeist as the driver
Capybara.default_driver = :headless_chrome

EPISODE_COUNT = 174
EPISODES_CSV_PATH = 'episodes.csv'
PEOPLE_CSV_PATH = 'people_episodes.csv'
RECOMMENDATIONS_CSV_PATH = 'recommendations.csv'

def find_recommendations_node(description_paragraphs)
  recommendation_title_para = description_paragraphs.find { |p| p.has_content?('Weekly Movie Recommendations:') }
  title_para_index = description_paragraphs.index(recommendation_title_para)
  description_paragraphs[title_para_index + 1]
end

def find_staff_picks_node(episode_page)
  episode_description_div = episode_page.find('.episode-description')
  description_paragraphs = episode_description_div.all('p')
  if episode_description_div.has_content?('Staff Picks')
    recommendations_node = description_paragraphs.find { |p| p.has_content?('Staff Picks') }
  else
    recommendations_node = find_recommendations_node(description_paragraphs)
  end
  puts "Found recommendations node"
  recommendations_node
end

def find_hosts_node(episode_page)
  description_paragraphs = episode_page.find('.episode-description').all('p')
  hosts_node = description_paragraphs.find {|p| p.has_content?('With ')}
  puts "Found hosts node"
  hosts_node
end

def print_text(node, node_name, episode_number)
  if node.nil?
    puts "Could not find #{node_name} for episode number #{episode_number}"
  else
    puts node.text
  end
end

def parse_hosts(hosts_node, episode_number)
  if hosts_node.nil?
    puts "No hosts node found"
  else
    host_data = []
    hosts_node.all('a').each do |host_link|
      name = host_link.text
      host_url = host_link['href']
      twitter_handle = nil
      if host_url.include?('twitter')
        twitter_handle = host_link['href'].split('twitter.com/').last
      end
      host_data << { name: name, twitter_handle: twitter_handle, episode_number: episode_number }
    end
    host_data
  end
end

def parse_episode_data(episode_page, episode_number)
  episode_title = episode_page.find('.episode-title')
  episode_date_node = episode_page.find('.episode-publish-date-and-duration').find('time')
  episode_date = nil
  begin
    episode_date = DateTime.strptime(episode_date_node.text, '%B %eth, %Y')
  rescue => error
    puts error
    puts "Failed to parse date for episode number #{episode_number} with title #{episode_title}"
  end
  puts "Found basic episode data for episode number #{episode_number}"
  {
    title: episode_title.text,
    episode_number: episode_number,
    date: episode_date
  }
end

def parse_recommendations(staff_picks_node, episode_number)
  recommendation_data = []
  staff_picks_node.all('a').each do |rec_name|
    item_name = rec_name.text
    if staff_picks_node.text.include?(' –')
      person_name = staff_picks_node.text.split(item_name).first.split(' –')[-2].split(' ').last
      # yes that dash is different somehow
    else
      person_name = staff_picks_node.text.split(item_name).first.split(' -')[-2].split(' ').last
    end
    recommendation_data << { item_name: item_name, person_name: person_name, episode_number: episode_number }
  end
  recommendation_data
end

browser = Capybara.current_session
CSV.open(EPISODES_CSV_PATH, "wb") do |csv|
  csv << [:title, :date, :number]
end
CSV.open(PEOPLE_CSV_PATH, "wb") do |csv|
  csv << [:name, :twitter_handle, :episode_number]
end
CSV.open(RECOMMENDATIONS_CSV_PATH, "wb") do |csv|
  csv << [:item_name, :person_name, :episode_number]
end

browser.visit 'https://radiopublic.com/who-shot-ya-G7Ndvk/episodes'
episode_items = browser.all('.episodeListEntry')
(77..102).each do |episode_index|
  begin
    episode_number = EPISODE_COUNT - episode_index
    episode_div = episode_items[episode_index]
    episode_div.find('.episodeTitles').click

    # On the episode show page
    puts "Pulling data for episode #{episode_number}"
    episode_info = parse_episode_data(browser, episode_number)
    CSV.open(EPISODES_CSV_PATH, "a") do |csv|
      csv << [episode_info[:title], episode_info[:date], episode_info[:episode_number]]
    end
    hosts_node = find_hosts_node(browser)
    parsed_hosts_info = parse_hosts(hosts_node, episode_number)
    unless parsed_hosts_info.nil?
      CSV.open(PEOPLE_CSV_PATH, "a") do |csv|
        parsed_hosts_info.each do |host|
          csv << [host[:name], host[:twitter_handle], host[:episode_number]]
        end
      end
    end
    staff_picks_node = find_staff_picks_node(browser)
    rec_info = parse_recommendations(staff_picks_node, episode_number)
    if rec_info.nil? || rec_info.empty?
      puts "Found no recommendations for episode #{episode_number}"
      byebug
    else
      puts rec_info
      CSV.open(RECOMMENDATIONS_CSV_PATH, "a") do |csv|
        rec_info.each do |rec|
          csv << [rec[:item_name], rec[:person_name], rec[:episode_number]]
        end
      end
    end

    # Return to episode list page
    browser.click_on '176 Episodes'
    episode_items = browser.all('.episodeListEntry')
  rescue => error
    puts "#" * 45
    puts "Failed to parse show information for item number #{episode_number}\n"
    puts "The error was:\n"
    puts error
    puts "#" * 45
    browser.click_on '176 Episodes'
    episode_items = browser.all('.episodeListEntry')
  end
end
puts "Completed pulling all data"


