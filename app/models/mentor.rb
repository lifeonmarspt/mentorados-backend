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

  def self.search(params)
    query = Mentor.all
    query = query.where(["name ilike ? or bio ilike ?", "%#{params[:string]}%", "%#{params[:string]}%"]) if params[:string]
    query = query.where({ gender: params[:gender] }) if params[:gender]
    query.joins(:careers).where(['careers.id in (?)', params[:career_ids]]).distinct
  end

end
