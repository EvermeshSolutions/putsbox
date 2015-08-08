class SimpleEmailSerializer < ActiveModel::Serializer
  root false

  attributes :id, :from_email, :from_name, :to, :email, :subject, :created_at

  def id
    object.id.to_s
  end
end
