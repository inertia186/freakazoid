freakazoid
==========

[Freakazoid](https://github.com/inertia186/freakazoid) is a cleverbot integrated bot for Hive.

#### Changes in v0.0.4

* Hive / Eclipse Update
* Gem Update

#### Features

* Added account name as Conversation ID so that Cleverbot maintains separate conversations with each account.
* Now sending a random sub-string for interaction greater than 140 characters.  This is so long posts don't flood Cleverbot, but also makes it seem like the bot read a specific part of the post and is reacting to it, just like a typical human.
* Added `except_apps` and `only_apps` config options, which helps avoid endless bot-on-bot conversations.
* The bot will now follow users who meet certain criteria.
* Added the ability to vote and self-vote if certain criteria have been met.

<center>
  <img src="http://i.imgur.com/635LS2j.jpg" />
</center>

---

This bot will automatically reply to posts and comments that reply to and mention the bot.  The replies are provided by the Cleverbot API.

The main reference implementation of Freakazoid is @banjo.  For example:

<center>
  <img src="http://i.imgur.com/zNN8tPE.png" />
</center>

---

#### Install

##### Linux

```bash
$ sudo apt-get update
$ sudo apt-get install ruby-full git openssl libssl1.0.0 libssl-dev
$ sudo apt-get upgrade
$ gem install bundler
```

##### macOS

```bash
$ gem install bundler
```

I've tested it on various versions of ruby.  The oldest one I got it to work was:

`ruby 2.0.0p645 (2015-04-13 revision 50299) [x86_64-darwin14.4.0]`

You can try the system version of `ruby`, but if you have issues with that, use this [how-to](https://hive.blog/ruby/@inertia/how-to-configure-your-mac-to-do-ruby-on-rails-development), and come back to this installation at Step 4:

##### Setup

First, clone this git and install the dependencies:

```bash
$ git clone https://github.com/inertia186/freakazoid.git
$ cd freakazoid
$ bundle install
```

##### Configure

Edit the `config.yml` file.

```yaml
:freakazoid:
  :block_mode: irreversible
  :account_name: <your Hive bot name>
  :posting_wif: <your Hive bot posting key>
  :cleverbot_api_key: <your cleverbot api key>

:chain_options:
  :chain: hive
  :url: https://api.hive.blog
```

In order to integrate with Cleverbot, you need to register your bot and get a key: https://www.cleverbot.com/api/


Edit the `support/reply.md` template (optional).

##### Run Mode

Then run it:

```bash
$ rake run
```

Freakazoid will now do it's thing.  Check here to see an updated version of this bot:

https://github.com/inertia186/freakazoid

---

#### Upgrade

Typically, you can upgrade to the latest version by this command, from the original directory you cloned into:

```bash
$ git pull
```

Usually, this works fine as long as you haven't modified anything.  If you get an error, try this:

```
$ git stash
$ git pull
$ git stash pop
$ bundle install
```

If you're still having problems, I suggest starting a new clone.

---

#### Troubleshooting

##### Problem: Everything looks ok, but every time Freakazoid tries to reply, I get this error:

```
Unable to reply with <account>.  Invalid version
```

##### Solution: You're trying to reply with an invalid key.

Make sure the `.yml` file contains the correct voting key and account name (`social` is just for testing).

##### Problem: The node I'm using is down.

Is there a list of nodes?

##### Solution: Yes, special thanks to @holger80.

https://hive.blog/@fullnodeupdate

---

## Tests

* Clone the client repository into a directory of your choice:
  * `git clone https://github.com/inertia186/freakazoid.git`
* Navigate into the new folder
  * `cd freakazoid`
* Basic tests can be invoked as follows:
  * `rake`
* To run tests with parallelization and local code coverage:
  * `HELL_ENABLED=true rake`

## Get in touch!

If you're using Freakazoid, I'd love to hear from you.  Drop me a line and tell me what you think!  I'm @inertia on Hive and Discord.
  
## License

I don't believe in intellectual "property".  If you do, consider Freakazoid as licensed under a Creative Commons [![CC0](http://i.creativecommons.org/p/zero/1.0/80x15.png)](http://creativecommons.org/publicdomain/zero/1.0/) License.
