-- EcoHabit: Create get_trending_posts RPC function
-- Trending score = (likes × 2 + comments) / (hours_since_posted + 2)^1.5

CREATE OR REPLACE FUNCTION get_trending_posts(result_limit INTEGER DEFAULT 10)
RETURNS TABLE (
  id UUID,
  content TEXT,
  post_type TEXT,
  author_id TEXT,
  likes_count INTEGER,
  comments_count INTEGER,
  created_at TIMESTAMP,
  trending_score DOUBLE PRECISION
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    p.id,
    p.content,
    p.post_type::TEXT,
    p.author_id,
    p.likes_count,
    p.comments_count,
    p.created_at,
    ((p.likes_count * 2 + p.comments_count)::DOUBLE PRECISION /
     POWER(EXTRACT(EPOCH FROM (now() - p.created_at)) / 3600 + 2, 1.5)) AS trending_score
  FROM posts p
  ORDER BY trending_score DESC
  LIMIT result_limit;
END;
$$ LANGUAGE plpgsql STABLE;
