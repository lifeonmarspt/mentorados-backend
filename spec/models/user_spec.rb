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

  context "searches mentors" do
    before do
      @careers = create_list(:career, 3)
      @traits = create_list(:trait, 3)
    end

    context "on careers" do
      before do
        @mentor1 = create(:user, :mentor, careers: @careers.first(2))
        @mentor2 = create(:user, :mentor, careers: @careers.last(1))
        @mentor3 = create(:user, :mentor, careers: @careers.last(2))
      end

      it "by a single career id" do
        mentors = User.search(career_ids: [ @careers[1].id ])
        expect(mentors).to match_array [@mentor1, @mentor3]
      end

      it "by multiple career ids" do
        mentors = User.search(career_ids: @careers.last(2).map(&:id))
        expect(mentors).to match_array [@mentor1, @mentor2, @mentor3]
      end

      it "by non-existent career id" do
        mentors = User.search(career_ids: [ -1 ])
        expect(mentors).to be_empty
      end
    end

    context "on traits" do
      before do
        @mentor1 = create(:user, :mentor, traits: @traits.first(2))
        @mentor2 = create(:user, :mentor, traits: @traits.last(1))
        @mentor3 = create(:user, :mentor, traits: @traits.last(2))
      end

      it "by a single trait id" do
        mentors = User.search(trait_ids: [ @traits[1].id ])
        expect(mentors).to match_array [@mentor1, @mentor3]
      end

      it "by multiple trait ids" do
        mentors = User.search(trait_ids: @traits.last(2).map(&:id))
        expect(mentors).to match_array [@mentor1, @mentor2, @mentor3]
      end

      it "by non-existent trait id" do
        mentors = User.search(trait_ids: [ -1 ])
        expect(mentors).to be_empty
      end
    end

    context "on string" do
      before do
        @mentor1 = create(:user, :mentor, name: "one word", careers: @careers)
        @mentor2 = create(:user, :mentor, name: "supa dupa", bio: "two word")
        @mentor3 = create(:user, :mentor, name: "three word", traits: @traits)
        @mentor4 = create(:user, :mentor, name: "james four", location: "mars")
      end

      it "matches name" do
        mentors = User.search(string: @mentor2.name)
        expect(mentors).to match_array [@mentor2]
      end

      it "matches bio" do
        mentors = User.search(string: @mentor2.bio)
        expect(mentors).to match_array [@mentor2]
      end

      it "matches location" do
        mentors = User.search(string: @mentor4.location)
        expect(mentors).to match_array [@mentor4]
      end

      it "matches trait description" do
        mentors = User.search(string: @traits.first.description)
        expect(mentors).to match_array [@mentor3]
      end

      it "matches career description" do
        mentors = User.search(string: @careers.first.description)
        expect(mentors).to match_array [@mentor1]
      end

      it "matches multiple fields" do
        mentors = User.search(string: "james mars")
        expect(mentors).to match_array [@mentor4]
      end

      it "does not match for non-existent values" do
        mentors = User.search(string: "wubalubadubdub")
        expect(mentors).to be_empty
      end
    end

    context "on multiple search parameters" do
      before do
        @mentor1 = create(:user, :mentor, name: "one word")
        @mentor2 = create(:user, :mentor, name: "supa dupa", careers: @careers)
        @mentor3 = create(:user, :mentor, name: "three word", traits: @traits)
        @mentor4 = create(:user, :mentor, location: "mars", careers: @careers, traits: @traits)
      end

      it "matches string and career_ids" do
        mentors = User.search(string: "supa", career_ids: @careers.first(1).map(&:id))
        expect(mentors).to match_array [@mentor2]
      end

      it "matches string and trait_ids" do
        mentors = User.search(string: "word", trait_ids: @traits.first(1).map(&:id))
        expect(mentors).to match_array [@mentor3]
      end

      it "matches career_ids and trait_ids" do
        mentors = User.search(career_ids: @careers.map(&:id), trait_ids: @traits.first(1).map(&:id))
        expect(mentors).to match_array [@mentor4]
      end

      it "matches string and career_ids and trait_ids" do
        mentors = User.search(string: "mars", career_ids: @careers.map(&:id), trait_ids: @traits.first(1).map(&:id))
        expect(mentors).to match_array [@mentor4]
      end
    end
  end
end
