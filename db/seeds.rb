# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = User.create!(
  email: 'admin@example.com',
  password: 'test123',
  role: 'admin'
)

student = User.create!(
  email: 'student@example.com',
  password: 'test123'
)

challenge_1 = Challenge.create!(
  sql_schema: (
<<-SQL
CREATE TABLE table1(id integer, name varchar(255));
SQL
  ),
  sql_correct_query: (
<<-SQL
SELECT table1.id from table1 ORDER BY table1.id ASC
SQL
  ),
  sql_seed: (
<<-SQL
INSERT INTO table1 (id, name) VALUES (1, "Vlad"), (2, "Michael"), (3, "Jordan");
SQL
  ),
  title: "Seed Challenge #1"
)

Submission.create!(
  user: student,
  challenge: challenge_1,
  sql_query: "SELECT * from table1"
)

Submission.create!(
  user: student,
  challenge: challenge_1,
  sql_query: "SELECT id from table1"
)

Submission.create!(
  user: student,
  challenge: challenge_1,
  sql_query: "SELECT id from table1 ORDER BY table1.id DESC"
)

Submission.create!(
  user: student,
  challenge: challenge_1,
  sql_query: "SELECT table1.id from table1 ORDER BY table1.id DESC"
)

Submission.create!(
  user: student,
  challenge: challenge_1,
  sql_query: "SELECT DISTINCT table1.id from table1 ORDER BY table1.id DESC"
)

Challenge.create!(
  sql_schema: (
<<-SQL
CREATE TABLE table1(id integer, name varchar(255));
CREATE TABLE table2(id integer, price integer, t1_id integer);
SQL
  ),
  sql_correct_query: (
<<-SQL
SELECT table1.id from table1 JOIN table2 on table2.t1_id = table1.id
SQL
  ),
  sql_seed: (
<<-SQL
INSERT INTO table1 (id, name) VALUES (1, "Vlad"), (2, "Michael"), (3, "Jordan");
INSERT INTO table2 (id, price, t1_id) VALUES (6, 10, 1), (7, 11, 2), (8, 111, 3), (9, 111, 3);
SQL
  ),
  title: "Seed Challenge #2"
)
