# Facebook (kind of)

This app is not intended to be a Facebook clone, instead, is about implementing
Ruby on Rails concepts to develop a social network application
(yes, another one). Right below there is a list of the features this project
has.

## Features

- **users** registration, authentication, edition
- **posts** creation, edition, and deletion
- **friendships** creation, rejection, canceling
- **likes** creation, deletion
- **comments** creation

## Setup

### Requirements

- `ruby` 2.6.5
- `rails` 5.1.7
- `postgres` 12.1
- `bundler` 2.0.2

### Steps

First clone the repository to any location you prefer.

```bash
git clone --single-branch --branch feature/friendships \
https://github.com/santiago-rodrig/facebook.git && \
cd facebook
```

Now, because this Rails app uses PostgreSQL, you need to setup your PostgreSQL
account. For that, you have to start PostgreSQL with the administrative account
**postgres**.

```bash
sudo -iu postgres
```

Now you are in the **postgres** account, and you can create users, databases,
alter user permission, etc. issue the command `psql` from the current shell
session.

#### Important

The user name should be the same as your current user name (the one you use to
login normally)

```sql
CREATE USER user_name WITH CREATEDB PASSWORD 'user_password';
```

In order to be able to login to `psql` from your regular user you need to create
a database with the same name as the new user created.

```bash
createdb --owner user_name user_name
```

Now you can `exit` from the **postgres** user session and go back to your
regular user session.

Now it is time to create the `.env` file containing the **SHELL variables** that
are going to be used to create the necessary databases that the app needs. Paste
(and replace the necessary things) this template.

```bash
POSTGRES_USER='user_name'
# by default is the current user name
POSTGRES_PASSWORD='user_password'
POSTGRES_DB='facebook' # change this if you want
POSTGRES_TEST_DB='facebook_test' # change this if you want
APP_ID='facebook_app_id'
APP_SECRET='facebook_app_secret'
```

The last two **SHELL variables** are the ones that hold the **Facebook app**
credentials, these are necessary in order for the app to be able to allow users
login using their Facebook account credentials. Go to
[Facebook developers](https://developers.facebook.com/), login, and create a new
app, then fill in the variables in the `.env` file.

Now, it's time to generate the databases with the Rails generators.

```bash
rails db:setup && rails db:migrate && ENV=test rails db:setup && \
ENV=test rails db:migrate
```

### Testing

There is a test suite available for you to run, in case that you think that
the app has some failing parts somewhere (hopefully not). Just run
`bundle exec rspec` to run the tests. If you decide to develop this app even
more you can use `bundle exec guard` while developing the new features to
run the tests in real time when you change things.

## Acknowledgements

This project is a task specified in
[The Odin Project](https://www.theodinproject.com/courses/ruby-on-rails/lessons/final-project).
And other things are specifications of the
[Microverse program](https://www.microverse.org/)

## Contact

If you want to reach out to me you can visit
[my Github profile](https://github.com/santiago-rodrig) or
[the LinkedIn one](https://www.linkedin.com/in/santiago-andr%C3%A9s-308a5b190?lipi=urn%3Ali%3Apage%3Ad_flagship3_profile_view_base_contact_details%3BtYchDkD4S7eoM%2BGocwG3SA%3D%3D).
