
## Scope of work

The API behaviour can be broken down into the following

1. As a user, I can create a new account
2. As a user, I can get account details
3. As a user, I can update my details

The functionality of the API is a simple CRU but with additional layer of complexity involving the use of API keys presented to the user

## Thought process

For this project I'm looking to use more out-of-the-box gems that comes with Rails, namely b-crypt for hashing password, jbuilder for serialization and secure random to generate api keys. That together is enough to build the initial MVP with all working functionalities. I'm using SQLite for the DB for simplicity's sake.

I later went and implemented an EncryptionService that's solely used to handle encryption of api key using JWT. Checking for token validity is also done by this service object. All testing is done using RSpec as specified, focusing more on controllers, models and services specs.

## Setting up the app

1. Clone this repo
2. Run `bundle`
3. Add this `application.yml` file into your config directory
```yml
default: &default
  ENCRYPTOR_KEY_PHRASE: 'secret'
  ENCRYPTOR_ALGORITHM: 'HS256'

development:
  <<: *default

test:
  <<: *default
```
4. Run `bundle exec rspec` to run RSpec tests
5. Run `rails s` to start

## Endpoints
In something like postman or in cUrl, you can make requests to the following endpoints.

1. Create a new user - `POST localhost:3000/users`
```json
// payload
{
  "first_name": "John",
  "last_name": "Doe",
  "email": "john.doe@email.com",
  "password": "password"
}

// Response
{
  "id": 1,
  "first_name": "John",
  "last_name": "Doe",
  "email": "john.doe@email.com",
  "tokem": <JWT_TOKEN> // To be used in getting and updating details
}
```

2. Get a user - `GET localhost:3000/users/{id}`
```json
// Headers
{
  "X-Api-Key": <JWT_TOKEN>
}

// Response
{
  "id": 1,
  "first_name": "John",
  "last_name": "Doe",
  "email": "john.doe@email.com"
}
```

3. Update a user - `PUT localhost:3000/users/{id}`
```json
// Headers
{
  "X-Api-Key": <JWT_TOKEN>
}

// Payload
{
  "id": 1,
  "first_name": "John",
  "password": "password" // Password required to perform update
}

// Response
{
  "id": 1,
  "first_name": "Jane",
  "last_name": "Doe",
  "email": "john.doe@email.com"
}
```