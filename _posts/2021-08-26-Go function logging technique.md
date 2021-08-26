---
title: Go function logging technique
image: /images/IMG_20210720_211108.webp
tags: Go
---

Sometimes I just want to time a function execution. the following does so in one line added to the beginning of the function.

```go
type logMark struct {
	name  string
	file  string
	line  int
	start time.Time
}

var wd, _ = os.Getwd()

func NewLogMark() logMark {
	pc, file, line, _ := runtime.Caller(1)
	return logMark{
		name:  runtime.FuncForPC(pc).Name(),
		file:  file,
		line:  line,
		start: time.Now(),
	}
}

func (o logMark) Log() {
	rel, _ := filepath.Rel(wd, o.file)
	log.Printf("%s:%d %s (Duration: %s)", rel, o.line, o.name, time.Now().Sub(o.start).String())
}
```

and can be used as follows
```go
func writeItem(destination, inbox, urlDigest string, item []byte) error {
	defer NewLogMark().Log()

	itemDigest := fmt.Sprintf("%x", sha1.Sum(item))
	itemFile := urlDigest + "-" + itemDigest + ".rss"
	itemPath := filepath.Join(inbox, itemFile)
	itemGlobPath := filepath.Join(destination, "**", itemFile)

	if matches, err := filepath.Glob(itemGlobPath); len(matches) > 0 || err != nil {
		return nil
	}

	return os.WriteFile(itemPath, item, os.ModePerm)
}
```

I just needed to add `defer NewLogMark().Log()` at the beginning of the function.

The line creates a new log mark with all the information about the caller function `writeItem` in this case. then defers the execution of `Log()` to the end of the function.

so it nicley creates a wrapper around the function code that will write information about the function execution at the end like so:

```
2021/08/26 12:41:46 main.go:181 main.writeItem (Duration: 4.507373ms)
```
