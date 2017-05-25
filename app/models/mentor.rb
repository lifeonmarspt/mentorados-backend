class Mentor < ApplicationRecord

  belongs_to :user, required: false
  has_many :mentors_careers
  has_many :careers, through: :mentors_careers
  has_many :mentors_locations
  has_many :locations, through: :mentors_locations

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, email: true
  validates :gender, presence: true, inclusion: { in: ['M', 'F'] }
  validates :bio, presence: true
  validates :picture, allow_nil: true, url: true
  validates :year_in,
    presence: true,
    inclusion: {
      in: 1900..Date.today.year,
      message: "should be a four-digit year"
    }
  validates :year_out,
    presence: false,
    allow_nil: true,
    inclusion: {
      in: 1900..Date.today.year,
      message: "should be a four-digit year"
    }

  SEARCHABLE_FIELDS = ["name", "bio", "locations.description", "careers.description"]

  def self.search_word(word)
    SEARCHABLE_FIELDS.map do |field|
      where(["unaccent(#{field}) ILIKE CONCAT('%', unaccent(?), '%')", word])
    end.reduce(&:or)
  end

  def self.search(params)
    mentors = Mentor.joins(:careers, :locations)

    mentors = sanitize_sql_like(params[:string]).
      split(/\s/).
      map { |word| mentors.search_word(word) }.
      reduce(mentors, &:merge)

    mentors = mentors.where(mentors_careers: { career_id: params[:career_ids] }) if params[:career_ids]
    mentors = mentors.where({ gender: params[:gender] }) if params[:gender] # this will be gone when we have traits

    mentors.distinct
  end
end
