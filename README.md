# Minimal Sinatra Web App

This is a minimal Ruby web application using Sinatra.

# Team

Our team consists of:

Daniel Kim (dk3506)

[Add your names here]

# Prerequisites

Ruby installed via rbenv

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
bundle install
```

# Run the App

```console
ruby app.rb
```

The server will start on local, look in your console to see the port/address.  
