from icecream import ic
import sqlite3


# 'movies.db' database will be created if not exists; but if it does it will establish connection
conn = sqlite3.connect('movies.db')
c = conn.cursor()


# f-strings f'blah' does not work.
def table_exists(table_name):
	c.execute('''SELECT count(name) FROM sqlite_master WHERE TYPE = 'table' AND name = '{}' '''.format(table_name))
	if c.fetchone()[0] == 1:
		return True
	return False


def insert_movie(movie_id, name, release_year, genre, rating):
	c.execute(''' INSERT INTO moviesdb (movie_id, name, release_year, genre, rating) VALUES(?, ?, ?, ?, ?) ''', (movie_id, name, release_year, genre, rating))
	conn.commit()


def get_movies():
	c.execute('''SELECT * FROM movies''')
	data = []
	for row in c.fetchall():
		data.append(row)

	return data


def get_movie(movie_id):
	c.execute('''SELECT * FROM movies WHERE movie_id = {}'''.format(movie_id))
	data = []
	for row in c.fetchall():
		data.append(row)

	return data


def update_movie(movie_id, update_dict):
	valid_keys = ['name', 'release_year', 'genre', 'rating']
	for key in update_dict.keys():
		if key not in valid_keys:
			raise Exception('Invalid field name!')

	for key in update_dict.keys():
		if type(update_dict[key]) == str:
			stmt = '''UPDATE movies SET {} = '{}' WHERE movie_id = {} '''.format(key, update_dict[key], movie_id)
		else:
			stmt = '''UPDATE movies SET {} = '{}' WHERE movie_id = {} '''.format(key, update_dict[key], movie_id)

		c.execute(stmt)
	conn.commit()

def delete_movie(movie_id):
	c.execute('''DELETE FROM movies WHERE movie_id = {}'''.format(movie_id))
	conn.commit()


# TODO:˚
# 	delete table


if __name__ == '__main__':
	if not table_exists('moviesdb'):
		c.execute('''
			CREATE TABLE moviesdb(
				movie_id INTEGER,
				name TEXT,
				release_year INTEGER,
				genre TEXT,
				rating REAL
			)
		''')

	# insert_movie(1, 'Titanic', 1997, 'Drama', 7.8)
	# insert_movie(2, 'The Day After Tomorrow', 2004, 'Action', 6.4)
	# insert_movie(3, '2012', 2009, 'Action', 5.8)
	# insert_movie(4, 'Men in Black', 1997, 'Action', 7.3)
	# insert_movie(5, 'World War Z', 2013, 'Romance', 10)
	insert_movie(6, 'Godzilla vs Kong', 2019, 'Thriller', 8.5)

	# ic(get_movie(2))
	ic(get_movie(6))
