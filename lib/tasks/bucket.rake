task clean_requests: :environment do
  # retention_period = 3.days.ago
  # Request.delete_all  created_at: { '$lt' => retention_period }
  # Response.delete_all created_at: { '$lt' => retention_period }
  #
  #
  # Not needed ^^^ anymore, it's using Mongo TTL 604800 = 3 days
  # db.requests.ensureIndex({ "created_at": 1 }, { expireAfterSeconds: 259200 })
  # db.responses.ensureIndex({ "created_at": 1 }, { expireAfterSeconds: 259200 })
  #
  # Need to recreate the indexes
  # db.requests.ensureIndex({ "bucket_id": 1, "created_at": -1 })
  # db.responses.ensureIndex({ "bucket_id": 1, "created_at": -1 })
  # db.responses.ensureIndex({ "request_id": 1 })
  #
  #
  # To prevent MongoLab blows the quota:
  # db.runCommand({ "convertToCapped": "requests",  size: 75000000 });
  # db.runCommand({ "convertToCapped": "responses", size: 75000000 });
  # I know, it should be the same value for both, but I don't know why MongoLab doesn't allow that.
end

task clean_buckets: :environment do
  retention_period = 3.months.ago

  Bucket.for_js('this.created_at = this.updated_at && this.last_email_at == null && this.created_at < retention', retention: retention_period).delete_all
end
