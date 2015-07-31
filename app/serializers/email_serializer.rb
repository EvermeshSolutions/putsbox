class EmailSerializer < ActiveModel::Serializer
  attributes :headers, :from_email, :from_name, :to, :email, :subject, :text, :html, :raw_msg
end
