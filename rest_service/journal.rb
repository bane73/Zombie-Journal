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


def load_sample_data() 
	Entry.create(
		:subject => "1st Entry",
		:body => "This is the 1st journal entry."
	)
	Entry.create(
		:subject => "2nd Entry",
		:body => "This is another sample entry."
	)
end
load_sample_data()

before do
	logger.info "Received request(key:#{params[:key]})"
	unless params[:key] =~ /^BRANDON$/
		logger.warn "UNAUTHORIZED USER MADE REQUEST TO API (key:#{params[:key]})"
		body haml "%h1 UNAUTHORIZED"
		halt 401
	end		
end

get "/" do	
	@num_entries = Entry.count
	haml :index
end

get "/entries.?:format?" do |format|
	@entries = Entry.all

	case format.upcase
	when "JSON"
		return @entries.to_json
	end unless format.nil?

	haml :entries
end

get "/entries/?:entry_id?.?:format?" do |entry_id, format|
	if entry_id.nil?
		redirect to( '/entries' )
	end

	@entry = Entry.get( entry_id )

	if @entry.nil?
		status 404
		return haml "%h1 NOT FOUND"
	end

	case format.upcase
	when "JSON"
		return @entry.to_json
	end unless format.nil?

	haml :entry
end

post "/entries" do
	request.body.rewind		# in case it's been read already somewhere else

	new_entry = Entry.createFromJson( request.body.read )

	if new_entry.nil? || new_entry.id.nil?
		status 400
		return haml "%h1 BAD REQUEST"
	end

	return new_entry.to_json
end







