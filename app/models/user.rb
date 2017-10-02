class User < ApplicationRecord
  has_secure_password validations: false

  has_many :mentors_careers
  has_many :user_traits
  has_many :careers, through: :mentors_careers, dependent: :destroy
  has_many :traits, through: :user_traits, dependent: :destroy

  validates :email, presence: true, uniqueness: true, email: true

  validates :name, presence: true, if: -> { mentor && active }
  validates :bio, presence: true, allow_blank: true, if: -> { mentor && active }
  validates :year_in, presence: true, if: -> { mentor && active }

  validate :validate_feup_email, on: :create, if: -> { student }

  scope :active_mentors, -> { where(mentor: true, active: true, blocked: false) }

  SEARCHABLE_FIELDS = ["name", "bio", "location", "careers.description", "traits.description"]

  attr_accessor :signup

  def student
    !admin && !mentor
  end

  def self.from_token_request request
    email = request.params["auth"] && request.params["auth"]["email"]
    self.where({ email: email }).where.not({ confirmed_at: nil }).first
  end

  def self.from_token_payload payload
    User.find(payload["id"])
  end

  def to_token_payload
    self.attributes.symbolize_keys.slice(:id)
  end

  def traits_list
    self.traits.map(&:description)
  end

  def traits_list= descriptions
    self.traits = descriptions.map { |d| d.strip.downcase }.uniq.map do |description|
      Trait.where(description: description).first_or_create!
    end
  end

  def self.search_word(word)
    SEARCHABLE_FIELDS.map do |field|
      where(["unaccent(#{field}) ILIKE CONCAT('%', unaccent(?), '%')", word])
    end.reduce(&:or)
  end

  def self.search(params)
    mentors = left_outer_joins(:careers, :traits)

    mentors = sanitize_sql_like(params[:string]).
      split(/\s/).
      map { |word| mentors.search_word(word) }.
      reduce(mentors, &:merge) if params[:string]

    mentors = mentors.where(mentors_careers: { career_id: params[:career_ids] }) if params[:career_ids]
    mentors = mentors.where(user_traits: { trait_id: params[:trait_ids] }) if params[:trait_ids]

    mentors.distinct
  end

  private
  def validate_feup_email
    if signup && email.split('@').last != "fe.up.pt"
      errors.add(:email, message: "must end with fe.up.pt")
    end
  end
end
