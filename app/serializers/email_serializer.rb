class EmailSerializer < ActiveModel::Serializer
  root false

  attributes :id, :headers, :from_email, :from_name, :to, :email, :subject, :text, :html, :attachments, :created_at

  def id
    object.id.to_s
  end
end
