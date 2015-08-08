class RecordEmail
  include Interactor::Organizer

  organize CreateOrRetrieveBucket, CreateEmail, NotifyCount, TrackEvent
end
