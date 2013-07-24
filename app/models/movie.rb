class Movie < ActiveRecord::Base

  after_destroy :cleanup_likes
  after_save :update_genres

  validates :name, :presence => true
  validates :year, :presence => true
  
  def likes
    $redis.smembers("movie:#{self.id}:likes").count
  end

  def liked_by_user_ids
    $redis.smembers("movie:#{self.id}:likes")
  end

  def genres=(genres_string)
    @genres = genres_string.split(",").collect {|genre| genre.strip.downcase }
  end

  def genres
    @genres = $redis.smembers("movie:#{self.id}:genres").join(", ")
  end

  def as_json(options = {})
    super(options.merge(:methods => [:likes]))
  end

  def to_xml(options = {})
    super(options.merge(:methods => [:likes]))
  end

  private

  def update_genres
    $redis.sadd("movie:#{self.id}:genres", @genres)
  end

  def cleanup_likes
    user_ids = self.liked_by_user_ids
    $redis.multi do
      $redis.del("movie:#{self.id}:likes")
      user_ids.to_a.each do |user_id|
        $redis.srem("user:#{user_id}:likes", self.id.to_s)
      end
    end
  end
end
