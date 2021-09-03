---
title: Country code to flag emojie in Go
---

I'm in the process of rewriting [my news website web interface](https://www.whoispopulartoday.com) in Go.

The interface is written in Ruby/Rails right now and I'm looking for improving my Go writing skills so I decided to rewrite this part in Go.

I have a function in my code that convert the country code like "eg" to it's flag emojie (you can see that at the bottom of the website or in the sidebar).

This code looks like so:

```ruby
def flag(code)
  code.upcase.tr('A-Z', "\u{1F1E6}-\u{1F1FF}")
end
```

After translating it to Go it looks like this:

```ruby
import (
	"golang.org/x/text/runes"
	"golang.org/x/text/transform"
)

var FlagReplacer = runes.Map(func(r rune) rune {
	return r - 'a' + '\U0001F1E6'
})

func Flag(code string) string {
	s, _, _ := transform.String(FlagReplacer, code)

	return s
}
```

this will return the flag emojie that correspond to the country code. for example "eg" will return "🇪🇬"
