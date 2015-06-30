require 'rails_helper'

describe Project do
  let!(:project) { FactoryGirl.create(:project) }

  describe '#rate=' do
    it 'returns Money' do
      project.update_attributes!(rate: 20)
      expect(project.rate).to eq(Money.new(2000, 'RUB'))
    end
  end

  describe '#users' do
    describe 'when users position is nobody' do
      let(:user)         { FactoryGirl.create :user, :nobody }
      let(:project_user) { FactoryGirl.build :project_user, user: user }
      it { expect(project_user.invalid?).to eq(true) }
    end

    describe 'when user position is not nobody' do
      let(:user)         { FactoryGirl.create :user, :chief }
      let(:project_user) { FactoryGirl.build :project_user, user: user }
      it { expect(project_user.valid?).to eq(true) }
      it { expect{ project.users << user }.to change{ project.users.count } }
    end
  end
end
