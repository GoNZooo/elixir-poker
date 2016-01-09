# Poker

## Usage

Run Poker.Check.check_several() to do checks. This can use your :pokees config
key, so it should be set in your config file.

You can also pass a list of pokees to check_several(), where the list can look
as follows:

    pokees = [
        [name: "google", url: "https://google.com/"],
        [name: "yahoo", url: "https://yahoo.com/"],
        [name: "HN", url: "https://news.ycombinator.com/"],
    ]
