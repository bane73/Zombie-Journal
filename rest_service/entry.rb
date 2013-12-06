# entry.rb

class Entry
  include DataMapper::Resource

  property :id, 					Serial
  property :subject, 				String,			:required => true, :length => 256
  property :body,					Text,			:required => true
  timestamps :created_at

end


