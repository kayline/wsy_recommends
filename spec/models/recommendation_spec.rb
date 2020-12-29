require 'rails_helper'

RSpec.describe Recommendation do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end