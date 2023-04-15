* In Delve there is a struct called [Debugger](https://pkg.go.dev/github.com/go-delve/delve@v1.20.2/service/debugger#Debugger)
* it has an unexported field called called [`targetMutex`](https://github.com/go-delve/delve/blob/d8ff5d1e43144605cf766f6a79ec5cd3371e07cb/service/debugger/debugger.go#L69)
* I want to access the `TryLock` method of this mutex in my package, but as it's not exported I can't do that

The following code is a workaround. it accesses the field and casts it to a pointer of `sync.Mutex`

```go
func TryLockTarget(d *debugger.Debugger) bool {
	field := reflect.ValueOf(d).Elem().FieldByName("targetMutex")
	mtx := reflect.NewAt(field.Type(), unsafe.Pointer(field.UnsafeAddr())).Interface()
	return mtx.(*sync.Mutex).TryLock()
}
```

The it's part of my Delve GUI. you can find the original snippet here: https://github.com/emad-elsaid/debugger/blob/610ca9315af1a6365cf95952bd08ef9b4c28ad61/debugger.go#L81

#go