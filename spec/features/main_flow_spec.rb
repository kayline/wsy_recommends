require 'rails_helper'

describe 'viewing recommendations' do
  before do
    episode1 = FactoryBot.create(:episode, number: 1, release_date: DateTime.new(2020, 11, 1))
    episode2 = FactoryBot.create(:episode, number: 2, release_date: DateTime.new(2020, 11, 15))
    greg = FactoryBot.create(:person, first_name: 'Thirst', last_name: 'von Trapp')
    FactoryBot.create(:recommendation, name: 'Teenage Mutant Ninja Turtles', episode: episode1)
    FactoryBot.create(:recommendation, name: 'Pacific Rim', person: greg, episode: episode2)
  end

  it 'displays an ordered list of all recommendations and shows the details for one' do
    visit '/'
    expect(page).to have_content('Teenage Mutant Ninja Turtles')
    expect(page).to have_content('Pacific Rim')
    titles = page.all('.recommendation-title').map {|node| node.text}
    expect(titles).to eq([
                              'Pacific Rim - Thirst von Trapp',
                              'Teenage Mutant Ninja Turtles - Christmas Zaddy'
                            ])
    click_on 'Pacific Rim'
    expect(page).to have_content('Thirst von Trapp')
    expect(page).to have_content('Episode 2')
  end
end