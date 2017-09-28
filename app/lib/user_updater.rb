module UserUpdater
  def self.update user, params
    if params.include?(:picture_url)
      if params[:picture_url].present?
        picture = base64_url params[:picture_url]
      else
        picture = gravatar_url params[:email]
      end

      params = params.merge(picture: picture)
    end

    user.update(params).tap do |success|
      delete_orphaned_traits if success
    end
  end

  def self.destroy user
    user.destroy.tap do |success|
      delete_orphaned_traits if success
    end
  end

  def self.gravatar_url email
    "https://www.gravatar.com/avatar/#{
      Digest::MD5.new.update(email).hexdigest
    }"
  end

  def self.base64_url url
    "data:;base64,#{Base64.encode64(Net::HTTP.get(URI(url)))}"
  end

  def self.delete_orphaned_traits
    Trait.left_joins(:user_traits).where(user_traits: { trait_id: nil }).delete_all
  end
end
