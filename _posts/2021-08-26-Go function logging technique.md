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

An improvement for this to reduce the logging is to print how many times the function was called and the average time.

```go
type logMark struct {
	name  string
	file  string
	line  int
	start time.Time
	end   time.Time
}

var wd, _ = os.Getwd()
var logMarks = map[string][]*logMark{}

func LogMarks() {
	for _, ms := range logMarks {
		if len(ms) == 0 {
			continue
		}

		var c int64 = 0
		var avg time.Duration = 0

		for _, m := range ms {
			avg = (time.Duration(c)*avg + m.end.Sub(m.start)) / time.Duration(c+1)
			c++
		}

		o := ms[0]
		rel, _ := filepath.Rel(wd, o.file)
		log.Printf("%s:%d %s %d Calls (Avg Duration: %s)", rel, o.line, o.name, c, avg.String())
	}
}

func NewLogMark() *logMark {
	pc, file, line, _ := runtime.Caller(1)

	return &logMark{
		name:  runtime.FuncForPC(pc).Name(),
		file:  file,
		line:  line,
		start: time.Now(),
	}
}

func (o *logMark) Log() {
	rel, _ := filepath.Rel(wd, o.file)
	log.Printf("%s:%d %s (Duration: %s)", rel, o.line, o.name, o.end.Sub(o.start).String())
}

func (o *logMark) Done() {
	o.end = time.Now()
	key := fmt.Sprintf("%s:%d", o.file, o.line)

	ms, ok := logMarks[key]
	if !ok {
		logMarks[key] = []*logMark{}
	}

	logMarks[key] = append(ms, o)
}
```

So instead of `defer NewLogMark().Log()` we'll call `defer NewLogMark().Done()` which adds the mark to a slice and we call `LogMarks()` at the end of our `main` function which will print statistics about the marks like so:

```
2021/08/27 11:30:58 main.go:183 main.writeItem 157 Calls (Avg Duration: 3.454063ms)
```

so instead of having 157 lines one for each execution we can group them together at the end.

This could be improved even more by calculating average directly in `Done()` to avoid cluttering memory with many `logMark` structures

```go
type logMark struct {
	name  string
	file  string
	line  int
	start time.Time
	end   time.Time
}

type logStat struct {
	name  string
	file  string
	line  int
	count int64
	avg   time.Duration
}

var wd, _ = os.Getwd()
var logStats = map[string]*logStat{}

func LogMarks() {
	for _, m := range logStats {
		rel, _ := filepath.Rel(wd, m.file)
		log.Printf("%s:%d %s %d Calls (Avg Duration: %s)", rel, m.line, m.name, m.count, m.avg.String())
	}
}

func NewLogMark() *logMark {
	pc, file, line, _ := runtime.Caller(1)

	return &logMark{
		name:  runtime.FuncForPC(pc).Name(),
		file:  file,
		line:  line,
		start: time.Now(),
	}
}

func (o *logMark) Log() {
	rel, _ := filepath.Rel(wd, o.file)
	log.Printf("%s:%d %s (Duration: %s)", rel, o.line, o.name, o.end.Sub(o.start).String())
}

func (o *logMark) Done() {
	o.end = time.Now()
	key := fmt.Sprintf("%s:%d", o.file, o.line)

	m, ok := logStats[key]
	if !ok {
		m = &logStat{
			name: o.name,
			file: o.file,
			line: o.line,
		}
		logStats[key] = m
	}

	m.avg = (time.Duration(m.count)*m.avg + o.end.Sub(o.start)) / time.Duration(m.count+1)
	m.count++
}
```
