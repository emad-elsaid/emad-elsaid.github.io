Prepending slice in Go

```go
package main

import (
    "fmt"
)

func main() {
    var x []int
    for i := 2; i < 10; i += 2 {
        x = append(x, i)
    }
    fmt.Println(x)

    // Prepending 1 to X 
    x = append([]int{1}, x...)

    fmt.Println(x)
}
```

# Reference

https://stackoverflow.com/questions/53737435/how-to-prepend-int-to-slice