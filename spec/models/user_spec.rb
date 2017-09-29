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

  context "searches and filters mentors" do
    before do
      @careers = 3.times.map{ create(:career) }
      @traits = 3.times.map{ create(:trait) }
    end

    it "by careers" do
      mentor1 = create(:user, :mentor, careers: @careers[0..1])
      mentor2 = create(:user, :mentor)
      mentor3 = create(:user, :mentor, careers: @careers[1..-1])

      mentors = User.search(career_ids: [ @careers[1].id ])
      expect(mentors).to match_array [mentor1, mentor3]

      mentors = User.search(career_ids: [ @careers[-1].id ])
      expect(mentors).to match_array [mentor3]
    end

    it "by traits" do
      mentor1 = create(:user, :mentor, traits: @traits[0..1])
      mentor2 = create(:user, :mentor)
      mentor3 = create(:user, :mentor, traits: @traits[1..-1])

      mentors = User.search(trait_ids: [ @traits[1].id ])
      expect(mentors).to match_array [mentor1, mentor3]

      mentors = User.search(trait_ids: [ @traits[-1].id ])
      expect(mentors).to match_array [mentor3]
    end

    it "by keywords" do
      mentor1 = create(:user, :mentor, name: "one word")
      mentor2 = create(:user, :mentor, name: "supa dupa", bio: "two word")
      mentor3 = create(:user, :mentor, name: "three word", traits: @traits)
      mentor4 = create(:user, :mentor, location: "the word")

      mentors = User.search(string: "word")
      expect(mentors).to match_array [mentor1, mentor2, mentor3, mentor4]

      mentors = User.search(string: "one three")
      expect(mentors).to match_array []

      mentors = User.search(string: "trait") # all generated traits have description = "trait#{index}"
      expect(mentors).to match_array [mentor3]

      mentors = User.search(string: "du word")
      expect(mentors).to match_array [mentor2]

      mentors = User.search(string: "du words")
      expect(mentors).to match_array []
    end

    it "by everything" do
      mentor1 = create(:user, :mentor, name: "one word")
      mentor2 = create(:user, :mentor, name: "supa dupa", careers: @careers)
      mentor3 = create(:user, :mentor, name: "three word", traits: @traits)
      mentor4 = create(:user, :mentor, location: "the word", careers: @careers, traits: @traits)

      mentors = User.search(string: "nope", career_ids: [ @careers[1].id ])
      expect(mentors).to match_array []

      mentors = User.search(string: "word", trait_ids: [ @traits[1].id ])
      expect(mentors).to match_array [mentor3, mentor4]

      mentors = User.search(string: "supa", career_ids: [ @careers[1].id ])
      expect(mentors).to match_array [mentor2]

      mentors = User.search(career_ids: [ @careers[1].id ], trait_ids: [ @traits[0].id ])
      expect(mentors).to match_array [mentor4]
    end
  end
end
