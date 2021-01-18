require 'rails_helper'

describe 'viewing recommendations' do
  before do
    thirst = FactoryBot.create(:person, first_name: 'Thirst', last_name: 'von Trapp')
    queen = FactoryBot.create(:person, :former_host, first_name: 'Midwest', last_name: 'Queen')
    inkoo = FactoryBot.create(:person, :guest, first_name: 'Inkoo', last_name: 'Disagrees')
    episode1 = FactoryBot.create(:episode, number: 1, people: [inkoo, queen], release_date: DateTime.new(2020, 11, 1))
    episode2 = FactoryBot.create(:episode, number: 2, people: [thirst], release_date: DateTime.new(2020, 11, 15))
    FactoryBot.create(:recommendation, name: 'Something Edgy', person: inkoo, episode: episode1)
    FactoryBot.create(:recommendation, name: 'Teenage Mutant Ninja Turtles', person: queen, episode: episode1)
    FactoryBot.create(:recommendation, name: 'Pacific Rim', person: thirst, episode: episode2)
  end

  it 'displays an ordered list of all recommendations and shows the details for one' do
    visit '/'
    expect(page).to have_content('Teenage Mutant Ninja Turtles')
    expect(page).to have_content('Pacific Rim')
    titles = page.all('.recommendation-title').map {|node| node.text}
    expect(titles).to eq([
                              'Pacific Rim - Thirst von Trapp',
                              'Something Edgy - Inkoo Disagrees',
                              'Teenage Mutant Ninja Turtles - Midwest Queen',
                            ])
    click_on 'Pacific Rim'
    expect(page).to have_content('Thirst von Trapp')
    expect(page).to have_content('Episode 2')
    click_on 'Who Shot Ya Recommends'
    expect(page).to have_content('Recommendations')
  end

  it 'shows a list of hosts and the recommendations for each' do
    visit '/'
    click_on 'Recs By Host'
    within('.current-hosts') do
      expect(page).to have_content('Thirst von Trapp')
    end
    within('.former-hosts') do
      expect(page).to have_content('Midwest Queen')
    end
    within('.guest-hosts') do
      expect(page).to have_content('Inkoo Disagrees')
    end
    click_on 'Thirst von Trapp'
    expect(page).to have_content('Pacific Rim')
    expect(page).not_to have_content('Teenage Mutant Ninja Turtles')
    expect(page).not_to have_content('Something Edgy')
  end
end