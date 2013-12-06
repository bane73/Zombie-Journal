# journal.rb

require 'rubygems'

# web service
require 'sinatra'

# ORM
require 'data_mapper'
DataMapper::Logger.new($stdout, :debug)
DataMapper.setup( :default, 'mysql://root@localhost/ruby' )
require_relative 'entry'
DataMapper.finalize
Entry.auto_migrate!

# JSON parsing
require 'json'

# MySQL database
require 'mysql2'


get '/' do	
	@entry = Entry.create(
		:subject => "My NEW entry!",
		:body => "This is it's body."
	)

	"Welcome to the Zombie Journal REST Service!"
end

get '/entries' do
	"All journal entries..."
end

get '/entries/?:entry_id?' do |entry_id|
	if entry_id.nil?
		redirect to( '/entries' )
	end

=begin
	client = Mysql2::Client.new( :host => "localhost", :username => "root", :database => "ruby" )
	results = client.query( "select * from entries where id='#{entry_id}'")
	client.close

	entry = nil
	results.each { |row| entry = row; break; }
	id = entry['id']
	subject = entry['subject']
	body = entry['body']
	timestamp = entry['timestamp']


	output = "<html><body>"
	output = "<h1>Journal entry (id:#{entry_id})</h1>"
	output << "<p>ID: #{id}</p>"
	output << "<p>SUBJECT: #{subject}</p>"
	output << "<p>BODY: #{body}</p>"
	output << "<p>TIMESTAMP: #{timestamp}</p>"	
	output << "</body></html>"
=end

	entry = Entry.get( entry_id )
	output = "<html><body>"
	output = "<h1>Journal entry (id:#{entry_id})</h1>"
	output << "<p>ID: #{entry.id}</p>"
	output << "<p>SUBJECT: #{entry.subject}</p>"
	output << "<p>BODY: #{entry.body}</p>"
	output << "<p>CREATED AT: #{entry.created_at}</p>"	
	output << "</body></html>"

end

post '/entries' do
	request.body.rewind		# in case it's been read already somewhere else
	data = JSON.parse request.body.read

client = Mysql2::Client.new( :host => "localhost", :username => "root", :database => "ruby" )
results = client.query('select * from entries')
results.each { |row| puts row['subject'] }
client.close

	"I was in a #{data['mood']} mood when I wrote: '#{data['body']}'."
end





