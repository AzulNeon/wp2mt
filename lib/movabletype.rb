module MovableType
  
  module Constants
    ENTRY_SEPARATOR = "--------\n"
    MULTI_LINE_FIELD_SEPARATOR = "-----\n"
    AUTHOR_FIELD_NAME = "AUTHOR"
    TITLE_FIELD_NAME = "TITLE"
    DATE_FIELD_NAME = "DATE"
    PRIMARY_CATEGORY_FIELD_NAME = "PRIMARY CATEGORY"
    CATEGORY_FIELD_NAME = "CATEGORY"
    ALLOW_COMMENTS_FIELD_NAME = "ALLOW COMMENTS"
    ALLOW_PINGS_FIELD_NAME = "ALLOW PINGS"
    COMMENT_FIELD_NAME = "COMMENT"
    EMAIL_FIELD_NAME = "EMAIL"
    BODY_FIELD_NAME = "BODY"
    STATUS_FIELD_NAME = "STATUS"
  end
    
  class Comment
    attr_accessor :author, :date, :email, :comment_content
    
    def to_s
      comment_string = ""
      comment_string += "#{MovableType::Constants::COMMENT_FIELD_NAME}:\n"
      comment_string += "#{MovableType::Constants::AUTHOR_FIELD_NAME}: #{@author}\n"
      comment_string += "#{MovableType::Constants::DATE_FIELD_NAME}: #{@date}\n"
      comment_string += "#{MovableType::Constants::EMAIL_FIELD_NAME}: #{@email}\n" unless  @email.nil? or @email.empty?
      comment_string += @comment_content.to_s
      comment_string += "\n"
      comment_string += MovableType::Constants::MULTI_LINE_FIELD_SEPARATOR
    end
  end
  
  class Entry
    attr_accessor :author, :title, :date, 
                  :category_list, :status, 
                  :allow_comments,:allow_pings,
                  :body, :comment_list                
    def initialize
      @allow_comments = 1
      @allow_pings = 1
      @category_list = []
      @comment_list = []
    end
    
    def to_s
      entry_string = ""
      entry_string += "#{MovableType::Constants::AUTHOR_FIELD_NAME}: #{@author}\n"
      entry_string += "#{MovableType::Constants::TITLE_FIELD_NAME}: #{@title}\n"
      entry_string += "#{MovableType::Constants::DATE_FIELD_NAME}: #{@date}\n"
      @category_list.each_with_index do |c, i|
        if i == 0
          entry_string += "#{MovableType::Constants::PRIMARY_CATEGORY_FIELD_NAME}: #{c}\n"
        else
          entry_string += "#{MovableType::Constants::CATEGORY_FIELD_NAME}: #{c}\n"
        end
      end
      entry_string += "#{MovableType::Constants::STATUS_FIELD_NAME}: #{@status}\n"
      entry_string += "#{MovableType::Constants::ALLOW_COMMENTS_FIELD_NAME}: #{@allow_comments}\n"
      entry_string += "#{MovableType::Constants::ALLOW_PINGS_FIELD_NAME}: #{@allow_pings}\n"
      entry_string += MovableType::Constants::MULTI_LINE_FIELD_SEPARATOR
      entry_string += "#{MovableType::Constants::BODY_FIELD_NAME}:\n"
      entry_string += @body
      entry_string += "\n"
      entry_string += MovableType::Constants::MULTI_LINE_FIELD_SEPARATOR
      @comment_list.each do |c|
        entry_string += c.to_s 
      end
      entry_string += MovableType::Constants::ENTRY_SEPARATOR
    end
  
  end  
  
  class BlogContent
    attr_accessor :entry_list
    
    def initialize
      @entry_list = []
    end
    
    def to_s
      blog_content_string = ""
      @entry_list.each do |e|
        blog_content_string += e.to_s
      end
    end
  end
  
end
