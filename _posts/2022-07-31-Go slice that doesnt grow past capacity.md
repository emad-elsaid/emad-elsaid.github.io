---
title: Go slice that doesn't grow past capacity
image: /images/IMG_20220730_175116.webp
---

A while ago I needed a Go slice that keeps growing until hitting capacity. after that I need it to discard the first item and add the new one to the end, without growing it's capacity.

`append` will grow Go slice if you tried to append an item when the slice used all of its capacity.

So what I did is a function that checks for the length of the slice and its capacity and if it's already full it'll copy all items past the first item back to index 0 which overwrite the first item leaving the last item empty. then append the new item to the end as normal.

And as Go introduced generics we can use the function with a slice of `any` type.

```go
func limitedAppend[T any](c *[]T, i T) {
	if len(*c) >= cap(*c) {
		copy((*c)[:len(*c)-1],(*c)[1:])
		*c = (*c)[:len(*c)-1]
	}

	*c = append(*c, i)
}
```

A use case for me was collecting some information periodically and making sure I keep the last 1000 items only.

```go
s := make([]int, 0, 10) // this will have 0 items and grow until 10 items
for i := 0; i < 100; i++ {
  limitedAppend(&s, i)
}
fmt.Println(s) // prints [90 91 92 93 94 95 96 97 98 99]
```

Go playground: https://go.dev/play/p/0MpcHN7OSTF
