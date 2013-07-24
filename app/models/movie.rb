class Movie < ActiveRecord::Base

  after_destroy :cleanup_likes

  def likes
    $redis.smembers("movie:#{self.id}:likes").count
  end

  def liked_by_user_ids
    $redis.smembers("movie:#{self.id}:likes")
  end

  def genres=(genres_string)
    @genres = genres_string.split(",").collect {|genre| genre.strip.downcase }
    $redis.sadd("movie:#{self.id}:genres", *genres)
  end

  def genres
    @genres = $redis.smembers("movie:#{self.id}:genres").join(", ")
  end

  private

  def cleanup_likes
    $redis.multi do
      user_ids = self.liked_by_user_ids
      $redis.del("movie:#{self.id}:likes")
      user_ids.each do |user_id|
        $redis.srem("user:#{user_id}:likes", self.id)
      end
    end
  end
end
