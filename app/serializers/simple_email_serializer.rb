class SimpleEmailSerializer < ActiveModel::Serializer
  attributes :id, :from_email, :from_name, :to, :email, :subject, :created_at

  def id
    object.id.to_s
  end
end
