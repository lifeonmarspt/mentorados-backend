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

end
