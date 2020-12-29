require 'rails_helper'

describe 'viewing recommendations' do
  before do
    episode = FactoryBot.create(:episode, number: 120)
    greg = FactoryBot.create(:person, first_name: 'Greg', last_name: 'Cobb')
    FactoryBot.create(:recommendation, name: 'Teenage Mutant Ninja Turtles')
    FactoryBot.create(:recommendation, name: 'Pacific Rim', person: greg, episode: episode)
  end

  it 'displays a list of all recommendations and shows the details for one' do
    visit '/'
    expect(page).to have_content('Teenage Mutant Ninja Turtles')
    expect(page).to have_content('Pacific Rim')
    click_on 'Pacific Rim'
    expect(page).to have_content('Greg Cobb')
    expect(page).to have_content('Episode 120')
  end
end