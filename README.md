# Rails Web App

This is a minimal Ruby web application using Sinatra.  Update as you go (please make your changes in your branch, and create PRs! Ask someone else to look over your changes, don't commit to main!)

# Prerequisites

Ruby installed via rbenv

Make sure you also have PostgreSQL installed.  
(Start it too, 
```bash
brew services start postgresql
```
on mac) 

Bundler gem (gem install bundler)

# Setup

Initialize rbenv in your shell

For zsh or bash, add the following to your shell session:

```console
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"   # or 'bash' if you use bash
```

# Verify Ruby installation:

```console
rbenv version
ruby -v
```

These should both be 3.4.2, if not run:

```console
rbenv install 3.4.2
rbenv global 3.4.2
source  ~/.bashrc   # or ~/.zshrc if on zsh
rbenv rehash
```

# Install dependencies:

```console
gem install rails
bundle install
rails db:migrate

```

# Run the App

```console
rails server
```

The server will start on local, look in your console to see the port/address.  
