class UserPolicy < ApplicationPolicy
  def index?
    @user&.admin
  end

  def mentors?
    @user
  end

  def create?
    !@user || @user.admin?
  end

  def show?
    @user && (@user.admin || @user.id == @record.id)
  end

  def update?
    @user && (@user.admin || @user.id == @record.id)
  end

  def permitted_attributes
    attributes = [:password]

    attributes += [:name, :bio, :year_in, :year_out, :picture_url, :location, :active, links: [], career_ids: [], traits_list: []] if @record.mentor
    attributes += [:email, trait_ids: []] if @user.admin || @record.mentor

    attributes += [:blocked] if @user.admin

    attributes
  end
end
