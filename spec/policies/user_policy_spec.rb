# http://www.thunderboltlabs.com/blog/2013/03/27/testing-pundit-policies-with-rspec/

require 'rails_helper'

describe UserPolicy do
  subject { UserPolicy.new(user, record) }

  context "as admin" do
    let(:user) { create(:user, :admin) }
    let(:record) { create(:user) }

    it { should permit(:index) }
    it { should permit(:mentors) }
    it { should permit(:create) }
    it { should permit(:show) }
    it { should permit(:update) }
    it { should permit(:destroy) }
    it { should permit(:index) }
  end

  context "as user / mentor" do
    let(:user) { create(:user) }

    context "seeing itself" do
      let(:record) { user }

      it { should permit(:mentors) }
      it { should permit(:show) }
      it { should permit(:update) }
      it { should permit(:destroy) }

      it { should_not permit(:create) }
    end

    context "seeing other" do
      let(:record) { create(:user) }

      it { should permit(:mentors) }

      it { should_not permit(:show) }
      it { should_not permit(:update) }
      it { should_not permit(:destroy) }
      it { should_not permit(:create) }
    end

  end

  context "logged out" do
    let(:user) { nil }
    let(:record) { create(:user) }

    it { should permit(:create) }
    
    it { should_not permit(:index) }
    it { should_not permit(:mentors) }
    it { should_not permit(:show) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end

  context "permitted_attributes" do
    subject do
      UserPolicy.new(user, record).permitted_attributes.map do |attr|
        attr.is_a?(Symbol) ? attr : attr.keys
      end.flatten
    end

    context "as user" do
      let(:user) { create(:user) }
      let(:record) { create(:user) }

      it "allows only correct attributes" do
        expected = %i(password)
        expect(subject).to match_array(expected)
      end
    end

    context "as admin" do
      let(:user) { create(:user, :admin ) }
      let(:record) { create(:user) }

      it "allows correct attributes" do
        expected = %i(password email trait_ids blocked admin)
        expect(subject).to match_array(expected)
      end
    end

    context "as anyone editing mentor" do
      let(:user) { create(:user) }
      let(:record) { create(:user, :mentor) }

      it "allows correct attributes" do
        expected = %i(password name bio year_in year_out picture_url location active links career_ids traits_list email trait_ids)
        expect(subject).to match_array(expected)
      end
    end
  end
end
