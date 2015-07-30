class RecordEmail
  include Interactor::Organizer

  organize CreateOrRetrieveBucket, CreateEmail, UpdateBucketStats
end
