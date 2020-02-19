# Facebook (kind of)

This app is not intended to be a Facebook clone, instead, is about implementing
Ruby on Rails concepts to develop a social network application
(yes, another one). Right below there is a list of the features this project
has.

#### Important

The live version of the app is in the following
[url](https://still-beyond-48768.herokuapp.com).

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
- `chromedriver`, make a google search for installing it in your current OS

### Steps

1. Clone the repository to any location you prefer.

```bash
git clone https://github.com/santiago-rodrig/facebook.git && cd facebook
```

2. Setup PostgreSQL. Read this [wiki page](https://github.com/santiago-rodrig/facebook/wiki/PostgreSQL-setup) to get information on how to do it.

3. Create the `.env` file that specifies the environment variables used by the application. Read this [wiki page](https://github.com/santiago-rodrig/facebook/wiki/Environment-variables) to get informed of the process.

4. Generate the databases with the Rails generators.

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
[The Odin Project](https://www.theodinproject.com/courses/ruby-on-rails/lessons/final-project),
and other things are specifications of the
[Microverse program](https://www.microverse.org/).

## Contact

If you want to reach out to me you can visit
[my Github profile](https://github.com/santiago-rodrig) or
[the LinkedIn one](https://www.linkedin.com/in/santiago-andr%C3%A9s-308a5b190?lipi=urn%3Ali%3Apage%3Ad_flagship3_profile_view_base_contact_details%3BtYchDkD4S7eoM%2BGocwG3SA%3D%3D).

## License

This project is licensed under the [MIT](https://github.com/santiago-rodrig/facebook/blob/master/LICENSE.md) license.
