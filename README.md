# NomNom - Smart Food Management App

**Eat smart. Waste less. NomNom more.**

A Ruby on Rails web application for managing grocery shopping, tracking food expiration dates, and discovering recipes.

---

## Project Iteration 1 Commit Hash

cafbda0ea4a2044535a6a44b676d805266e08502

---

## Project Iteration 2 Commit Hash

9216396c856b7c102449bcdb8a1c0eafbed7733c

---

## Team 10

- **Daniel Kim** - (dk3506)
- **Minsuk Kim** - (mk4434)
- **Rebecca Zhao** - (rz2763)
- **Eric Chen** - (yc4670)

---

## Prerequisites

- Ruby 3.4.2 (via rbenv)
- PostgreSQL
- Bundler gem

### Install PostgreSQL

**On macOS:**

```bash
brew install postgresql@15
brew services start postgresql@15
```

**On Linux:**

```bash
sudo apt-get install postgresql postgresql-contrib
sudo service postgresql start
```

---

## Setup

### 1. Clone the repository

```bash
git clone https://github.com/D-SehKim/SaaS_Project.git
cd SaaS_Project/NomNom
```

### 2. Install Ruby 3.4.2

```bash
rbenv install 3.4.2
rbenv local 3.4.2
```

### 3. Install dependencies

```bash
gem install bundler
bundle install
```

### 4. Setup database

```bash
rails db:create
rails db:migrate
rails db:seed  # Optional: adds sample data
```

### 5. Run the application

```bash
rails server
```

The app will be available at `http://localhost:3000`

---

## Usage

1. **Sign up** for a new account or **log in**
2. Navigate to:
   - **Grocery List** - Plan your shopping trips
   - **Expiration Tracker** - Monitor food freshness
   - **Recipe Search** - Find recipes using your ingredients

---

## Heroku/Heroku Link

```
git push heroku master
```

The link is [https://nomnom-app-040d7eb8feb7.herokuapp.com/](https://nomnom-app-040d7eb8feb7.herokuapp.com/)

### Running tests

```bash
# Run all tests
# cd NomNom if you're in the outside folder
bundle exec rspec

# Run Cucumber features
bundle exec cucumber
```

The tests can be seen under their folders respectivly, i.e "/NomNom/spec" for RSpec, and "/NomNom/features" for Cucumber.  

---

## Contributing

1. Create a feature branch (`git checkout -b feature/your-feature`)
2. Commit your changes (`git commit -m 'Add some feature'`)
3. Push to the branch (`git push origin feature/your-feature`)
4. Create a Pull Request
5. Request review from team members

---

## License

This project is part of a Columbia University SaaS course assignment.

---

## Acknowledgments

- Built with Ruby on Rails
- Used devise for login applications
