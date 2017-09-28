require 'rails_helper'

RSpec.describe User do

  it "creates students with an fe.up.pt email" do
    user = build(:user, signup: true, email: "student@fe.up.pt")
    expect(user.valid?).to be true
  end

  it "does not create students without an fe.up.pt email" do
    user = build(:user, signup: true, email: "nope@nope.nope")
    expect(user.valid?).to be false
  end

  it "removes only career / trait associations on destroy" do
    career = create(:career)
    trait = create(:trait)
    user = create(:user, careers: [ career ], traits: [ trait ])

    user.destroy

    expect(UserTrait.all).to be_empty
    expect(MentorsCareer.all).to be_empty
    expect(Trait.all).not_to be_empty
    expect(Career.all).not_to be_empty
  end
end
