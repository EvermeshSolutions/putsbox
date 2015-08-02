class EmailSerializer < ActiveModel::Serializer
  root false

  attributes :id, :headers, :from_email, :from_name, :to, :email, :subject, :text, :html, :raw_msg, :created_at

  def id
    object.id.to_s
  end
end
