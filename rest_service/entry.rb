# entry.rb

require 'json'

class Entry
  include DataMapper::Resource

  property :id, 					Serial
  property :subject, 				String,			:required => true, :length => 256
  property :body,					Text,			:required => true
  timestamps :created_at

  def self.createFromJson( jsonString )
  	data = JSON.parse( jsonString )

  	Entry.create(
  		:subject => data['subject'],
  		:body => data['body']
	)

  end

end


