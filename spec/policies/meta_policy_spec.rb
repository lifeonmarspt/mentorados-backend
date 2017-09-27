# http://www.thunderboltlabs.com/blog/2013/03/27/testing-pundit-policies-with-rspec/

require 'rails_helper'

RSpec.describe MetaPolicy do
  subject { MetaPolicy.new(user, record) }

  context "logged in" do
    let(:user) { create(:user) }
    let(:record) { nil }

    it { should permit(:index) }
  end

  context "logged out" do
    let(:user) { nil }
    let(:record) { nil }

    it { should_not permit(:index) }
  end
end
