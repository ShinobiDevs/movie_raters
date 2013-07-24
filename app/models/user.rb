class User < ActiveRecord::Base

  validates :email, :uniqueness => true

  after_destroy :cleanup_likes

  def liked_movies_count
    liked_movies_ids.count
  end

  def liked_movies_ids
    $redis.smembers("user:#{self.id}:likes")
  end

  def likes_movie?(movie)
    $redis.sismember("movie:#{movie.id}:likes", self.id)
  end

  def unlike!(movie)
    $redis.multi do
      $redis.srem("movie:#{movie.id}:likes", self.id)
      $redis.srem("user:#{self.id}:likes", movie.id)
    end
  end

  def like!(movie)
    $redis.multi do
      $redis.sadd("movie:#{movie.id}:likes", self.id)
      $redis.srem("user:#{self.id}:likes", movie.id)
    end
  end

  def as_json(options = {})
    super(options.merge(:methods => [:liked_movies_count]))
  end

  private

  def cleanup_likes
    $redis.multi do
      movie_ids = self.liked_movies_ids
      $redis.del("user:#{self.id}:likes")
      movie_ids.each do |movie_id|
        $redis.srem("movie:#{movie_id}:likes", self.id)
      end
    end
  end
end
