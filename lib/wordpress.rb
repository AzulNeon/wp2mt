module WordPress
  
  class ConnectionError < Exception
    
    def initialize(e)
      @e = e
    end
    
    def message 
      puts "An error occurred"
      puts "Error code: #{@e.err}"
      puts "Error message: #{@e.errstr}"
    end
    
  end
  
  class Connection
    def initialize(database_name, host, port, user, pass, table_prefix)
      @database_name = database_name
      @host = host
      @port = port
      @user = user
      @pass = pass
      @table_prefix = table_prefix
    end
    
    def get_blog_content
      connect unless @connection
      blog_content = MovableType::BlogContent.new
      get_entries.each { |e| blog_content.entry_list << e}
      @connection.disconnect
      @connection = nil
      blog_content
    end
  
    private 
    
    def get_entries
      entry_list = []
      all_entries_query = <<-ALL_ENTRIES_QUERY
      select user_nickname, post_title, DATE_FORMAT(post_date, '%m/%d/%Y %k:%i:%s'), post_status, post_content, p.id
      from #{@table_prefix}_posts p, #{@table_prefix}_users u
      where p.post_author = u.id
      ALL_ENTRIES_QUERY
      entries = @connection.select_all(all_entries_query)
      entries.each do |e|
        entry = MovableType::Entry.new
        entry.author = e[0]
        entry.title  = e[1]
        entry.date   = e[2]
        entry.status = e[3]
        entry.body   = e[4]
        entry_id     = e[5]  
        get_categories(entry_id).each { |c| entry.category_list << c } 
        get_comments(entry_id).each { |c| entry.comment_list << c }
        entry_list << entry
      end
      entry_list
    end
    
    def get_categories(entry_id)
      category_list = []
      entry_categories_query = <<-ENTRY_CATEGORIES_QUERY
        select cat_name 
        from #{@table_prefix}_categories c, #{@table_prefix}_post2cat p2c, #{@table_prefix}_posts p 
        where p.id = #{entry_id} and p.id = p2c.post_id and p2c.category_id = c.CAT_id
      ENTRY_CATEGORIES_QUERY
      categories = @connection.select_all(entry_categories_query)
      categories.each do |c|
        category_list << c
      end
      category_list
    end
    
    def get_comments(entry_id)
      comment_list = []
      entry_comments_query = <<-ENTRY_COMMENTS_QUERY
        select comment_author, DATE_FORMAT(comment_date, '%m/%d/%Y %k:%i:%s'), comment_author_email, comment_content 
        from #{@table_prefix}_comments c, #{@table_prefix}_posts p 
        where p.id = comment_post_id and p.id = #{entry_id}
      ENTRY_COMMENTS_QUERY
      comments = @connection.select_all(entry_comments_query)
      comments.each do |c|
        comment = MovableType::Comment.new
        comment.author = c[0]
        comment.date = c[1]
        comment.email = c[2]
        comment.comment_content = c[3]
        comment_list << comment
      end
      comment_list
    end
    
    def connect
      begin
      @connection = DBI.connect("DBI:Mysql:database=#{@database_name};host=#{@host};port=#{@port}",@user,@pass)
      rescue DBI::DatabaseError => e
        raise WordPress::ConnectionError.new(e)
      end
    end
    
    def disconnect
      @connection.disconnect if @connection
    end
  end
end
