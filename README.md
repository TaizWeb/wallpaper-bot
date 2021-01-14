# Wallpaper Bot
> A lua script to post a random wallpaper to an activitypub account

## Requirements
* A linux shell (for the `sleep` command)
* lua5.3
* curl
* An account to post to

## Setup
First, sign up on any valid instance on the [Fediverse](https://en.wikipedia.org/wiki/Fediverse), then read the [mastodon docs](https://docs.joinmastodon.org/client/token/) on getting an access token. After you've both created an account and obtained the access token, create `config.txt` in the `src/` folder and add the following lines to it:
```
domain https://<your_instance>
token <your_access_token>
```
After that, simply run `lua main.lua` while in the `src/` folder and the bot will post a random wallpaper every hour.

## License
The code is licensed under the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html), so if you run this bot on an instance, the repo containing the code the bot is using **must be publicly available**. A simple link in the bio should suffice.

