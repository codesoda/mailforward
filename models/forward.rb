class Forward
  include DataMapper::Resource

  property :key, String, key: true
  property :username, String
  property :email, String
end