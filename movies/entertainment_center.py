import media
import fresh_tomatoes

toy_story = media.Movie("Toy Story"
                        , "A story of a boy and his toy that comes to life"
                        , "https://upload.wikimedia.org/wikipedia/en/1/13/Toy_Story.jpg"
                        , "https://www.youtube.com/watch?v=vwyZblah")

#print(toy_story.trailer_youtube_url)

avatar = media.Movie("Avatar"
                     , "A marine on an alient planet"
                     , "https://upload.wikimedia.org/wikipedia/id/b/b0/Avatar-Teaser-Poster.jpg"
                     , "http://www.youtube.com/watch?v=5PSNL1qE6VY")

schoolofrock = media.Movie("School of Rock"
                     , "Using rock music to earn through university college degree"
                     , "https://upload.wikimedia.org/wikipedia/en/1/11/School_of_Rock_Poster.jpg"
                     , "https://www.youtube.com/watch?v=XCwy6lW5Ixc")

frozen = media.Movie("Frozen"
                     , "One of two sisters is a frozen queen uses her powers to save her home"
                     , "https://upload.wikimedia.org/wikipedia/en/0/05/Frozen_%282013_film%29_poster.jpg"
                     , "https://www.youtube.com/watch?v=TbQm5doF_Uc")

#need to put all movies into an array
movies = [toy_story, avatar, schoolofrock, frozen]
fresh_tomatoes.open_movies_page(movies)


#print(avatar.trailer_youtube_url)
#print(avatar.storyline)
#avatar.show_trailer()