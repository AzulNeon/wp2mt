require 'dbi'
require 'wordpress'
require 'movabletype'
require 'getoptlong'


class Wp2Mt

  def initialize 
    @database = ""
    @host = ""
    @port = ""
    @user = ""
    @password = ""
    @table_prefix = ""
    @opts = GetoptLong.new( 
    ['--database', '-d', GetoptLong::REQUIRED_ARGUMENT],
    ['--host', '-h', GetoptLong::REQUIRED_ARGUMENT],
    ['--port', '-p', GetoptLong::REQUIRED_ARGUMENT],
    ['--user', '-u', GetoptLong::REQUIRED_ARGUMENT],
    ['--password', '-P', GetoptLong::REQUIRED_ARGUMENT],
    ['--table-prefix', '-t', GetoptLong::REQUIRED_ARGUMENT]
    )
  end
  
  def do_conversion
    parse_args
    if check_mandatory_params
      begin
        puts    WordPress::Connection.new(@database,@host,@port,@user,@password,@table_prefix).get_blog_content.to_s  
      rescue WordPress::ConnectionError => e
        puts e.message
      end
    else
      print_usage
    end
  end

  private
   
  def parse_args
    @opts.each do |opt, arg| 
      case opt
        when '--database'
          @database = arg
        when '--host'
          @host = arg
        when '--port'
          @port = arg
        when '--user'
          @user = arg
        when '--password'
          @password = arg
        when '--table-prefix'
          @table_prefix = arg
      end
    end
  end

  def check_mandatory_params
    not @database.empty? and not @host.empty? and not @user.empty? and not @password.empty? and not @table_prefix.empty?
  end

  def print_usage
    puts 'wp2mt --database database --host host --port port --user user --password password --table-prefix table_prefix'
  end



end



