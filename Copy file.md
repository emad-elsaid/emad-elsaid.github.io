#go doesn't have a function to copy files. the following is a simple implementation.

It seams it uses one `Copy` function so I guess this is suitable for small files as large files will take too long and there is no way to know the progress or cancel it.

So use it for files that you expect to be small.

```go
func copyFile(src, dst string) error {
	in, err := os.Open(src)
	if err != nil {
		return err
	}
	defer in.Close()

	out, err := os.Create(dst)
	if err != nil {
		return err
	}
	defer out.Close()

	_, err = io.Copy(out, in)
	if err != nil {
		return err
	}
	return out.Close()
}
```
