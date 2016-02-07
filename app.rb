require 'data_mapper'
require 'json'
require 'redis'
require 'sinatra'

require 'models/forward'

require 'byebug'

# Setup DataMapper with a database URL. On Heroku, ENV['DATABASE_URL'] will be
# set, when working locally this line will fall back to using SQLite in the
# current directory.
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite")

# Finalize the DataMapper models.
DataMapper.finalize

# Tell DataMapper to update the database according to the definitions above.
DataMapper.auto_upgrade!

redis = Redis.new

get '/forwards' do
  content_type :json

  forwards = Forwards.all
  #forwards = (redis.smembers('forward_keys') || []).map do |key|
  #  JSON.parse(redis.get("forward:#{key}"))
  #end

  { forwards: forwards }.to_json
end

post '/forwards' do
  content_type :json

  key = params[:key]

  forward = Forward.create(
    key: key,
    username: params[:username],
    email: params[:email]
  )

  { forward: forward }.to_json
end

get '/forward/:key' do
  key = params[:key]
  json = redis.get("forward:#{key}")
  if json
    forward = JSON.parse(json)
    { forward: forward }.to_json
  else
    halt 404
  end
end

patch '/forward/:key' do
  content_type :json

  key = params[:key]
  forward = redis.get("forward:#{key}")
  if forward
    forward = {
      key: key,
      username: params[:username],
      email: params[:email]
    }
    redis.set "forward:#{key}", forward.to_json

    # reconfigure postfix
    #ReconfigurePostfixJob.new.async.perform

    { forward: forward }.to_json
  else
    halt 404
  end
end
