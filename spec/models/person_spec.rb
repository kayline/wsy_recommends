require 'rails_helper'

describe Person do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end

  describe 'ordered scope' do
    let(:person1) { FactoryBot.create(:person) }
    let(:person2) { FactoryBot.create(:person) }
    let!(:newer_episode) { FactoryBot.create(:episode, people: [person2], release_date: DateTime.new(2020,12,1)) }
    let!(:older_episode) { FactoryBot.create(:episode, people: [person1], release_date: DateTime.new(2020,11,1)) }

    it 'sorts by the date of the most recent episode each person was on' do
      expect(Person.ordered).to eq([person2, person1])
    end
  end
end