require "httpclient"

@results = []
@io = STDOUT

client = HTTPClient.new

ARGV.each do |arg|
	result = nil

	begin
		res = client.get(arg)
		case res.status_code
		when 400...500
			result = { success: false, url: arg, status_code: res.status_code }
		when 500...600
			result = { success: false, url: arg,  status_code: res.status_code }
		else
			result = { success: true, url: arg }
		end
	rescue => e
		result = { success: false, url: arg, error: e }
	ensure
		@results << result
	end
end

@results.each do |result|
	@io.print "#{result[:success] ? "success" : "FAILURE" } #{result[:url]}"

	case
	when result[:status_code]
		@io.print "   (status_code = #{result[:status_code]})"
	when result[:error]
		@io.print "   (error = #{result[:error].inspect})"
	end

	@io.puts
end

exit(@results.select{|result| result[:success] == false }.count)
