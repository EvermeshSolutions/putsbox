PutsBox::Application.routes.draw do
  devise_for :users

  root to: 'home#index'

  post 'buckets' => 'buckets#create', as: :buckets
  get ':token/inspect' => 'buckets#show', as: :bucket
  put ':token/buckets' => 'buckets#update', as: :update_bucket

  post '/record' => 'buckets#record', via: :all, as: :bucket_record

  delete ':token/delete' => 'buckets#destroy', as: :bucket_destroy
  delete ':token/clear' => 'buckets#clear', as: :bucket_clear

  get ':token/:id' => 'emails#show', as: :email, subdomain: 'preview'
end
