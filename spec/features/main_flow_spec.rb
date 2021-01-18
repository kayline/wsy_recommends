require 'rails_helper'

describe 'viewing recommendations' do
  before do
    episode1 = FactoryBot.create(:episode, number: 1, release_date: DateTime.new(2020, 11, 1))
    episode2 = FactoryBot.create(:episode, number: 2, release_date: DateTime.new(2020, 11, 15))
    thirst = FactoryBot.create(:person, first_name: 'Thirst', last_name: 'von Trapp')
    queen = FactoryBot.create(:person, first_name: 'Midwest', last_name: 'Queen')
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
                              'Teenage Mutant Ninja Turtles - Midwest Queen'
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
    expect(page).to have_content('Thirst von Trapp')
    expect(page).to have_content('Midwest Queen')
    click_on 'Thirst von Trapp'
    expect(page).to have_content('Pacific Rim')
    expect(page).not_to have_content('Teenage Mutant Ninja Turtles')
  end
end