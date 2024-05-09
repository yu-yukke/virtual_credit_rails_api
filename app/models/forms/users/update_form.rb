class Forms::Users::UpdateForm
  include ActiveModel::Model

  attr_accessor :name, :slug, :description, :thumbnail_image, :user

  def initialize(user, attributes = {})
    @user = user
    @attributes = attributes

    @attributes.each do |name, value|
      public_send(:"#{name}=", value) if respond_to?(:"#{name}=")
    end
  end

  def save!
    ActiveRecord::Base.transaction do
      assign_user_attributes
      attach_thumbnail_image if attributes_provided.key?(:thumbnail_image)

      user.save!
    end
  end

  private

  def assign_user_attributes
    update_attrs = {}
    update_attrs[:name] = name if attributes_provided.key?(:name)
    update_attrs[:slug] = slug if attributes_provided.key?(:slug)
    update_attrs[:description] = description if attributes_provided.key?(:description)

    user.assign_attributes(update_attrs) unless update_attrs.empty?
  end

  def attach_thumbnail_image
    user.thumbnail_image.attach(thumbnail_image)
  end

  def attributes_provided
    @attributes_provided ||= {}.tap do |attrs|
      attrs[:name] = true if @attributes.key?(:name)
      attrs[:slug] = true if @attributes.key?(:slug)
      attrs[:description] = true if @attributes.key?(:description)
      attrs[:thumbnail_image] = true if @attributes.key?(:thumbnail_image)
    end
  end
end
