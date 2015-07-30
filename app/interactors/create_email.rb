class CreateEmail
  include Interactor

  def call
    context.email.bucket = context.bucket
    context.email.save
  end
end
