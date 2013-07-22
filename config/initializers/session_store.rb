# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_pomodo_session',
  :secret      => '8e8f03d92e1b5139116c5aa0b4e32bd64141e9cea064f8ad954cebc0d7f8404653b98701f7ded9aac00a957cd4db3dc6791dc6d9a35fa996ed61103def6f510a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
