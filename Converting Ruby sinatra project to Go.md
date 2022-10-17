![](/public/IMG_20211214_154230.webp)

#go 

I have a small side project written in Ruby. It uses PostgreSQL database, Sinatra framework and ActiveRecord. The project is meant to replace my goodreads for my use case.

I wanted to practice Go more. So it is a good opportunity to write this same project in Go. My goal is to get to translate my Ruby/Sinatra/ActiveRecord skills to Go tools. And as the project is small it shouldn't take forever to do it.

The aim for me was to have similar experience as Sinatra classic syntax. and it looks something like this

```ruby
get "path/to/handle" do
// your request handler here
// return the response as string
end
```

in this case `get` is the request method to handle. it takes two arguments:
- the path to handle
- a block to execute (ruby block is just a fancy way to send a closure to a function)

My whole effort was aiming at having this experience when writing the main function. And I broke all the rules to achieve it.

# Global Variables

So a basic example for a Go HTTP handler takes the following form

```go
func(w http.ResponseWriter, req *http.Request) {
// handle request here and write to response
}
```

And then you need to have a muxer that takes this function and execute it based on the path. I used [Gorilla mux](https://github.com/gorilla/mux) because it supports dynamic segments in the path.

So if you're defining a method like the above you have to add it to the mux. but in sinatra you just call `get` so in order to achieve that. I created a file `common.go` which will have all common code that is not really my logic. like connecting to DB, running the server. creating the mux...etc stuff that can be ported to any project and I then need to write only the sinatra like functions/blocks

so in `common.go` I defined an `init` function which is everything that will be executed before the `main` function. and another function that starts the server called `start` so in my main I should define the handlers then call `start()`.

In the `init` function I defined the mux/router

```go
router = mux.NewRouter()
```

Where `router` is global variable. to add a handler to `router` the syntax looks like this

```go
router.Methods("GET").Path(path).HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
// handle request here and write to response
})
```

I don't want to have this in my `main` code. so better hide it. If I defined a function called `GET` to hide this ugliness it should look like this

```go
func GET(path string, handler http.HandlerFunc) {
	router.Methods("GET").Path(path).HandlerFunc(handler)
}
```

so now I can define get handlers in my main like so

```go
GET("/path/to/handle", func(w http.ResponseWriter, r *http.Request) {
// handle request here and write to response
})
```

That's better, and same pattern I defined `POST` and `DELETE` functions. there is one thing that annoys me. `http.ResponseWriter` and `*http.Request` are too verbose. I wish there is a way to make it shorter. So I broke another rule

# Type aliases

I defined two type aliases in `common.go` for `http.ResponseWriter` and `*http.Request`

```go
type Response = http.ResponseWriter
type Request = *http.Request
```

Now my handlers will look better

```go
GET("/path/to/handle", func(w Response, r Request) {
// handle request here and write to response
})
```

# All the returns drives me mad

I found that I have a pattern.

- I get the arguments
- I query the DB
- If something is wrong I use `http.Error` and then `return`
- When I want to render something in the middle of the function I render then return.

It looked something like this

```go
GET("/path/to/handle", func(w Response, r Request) {
  actor := current_user(r)
  vars := mux.Vars(r)

  user, err := queryForUser(vars["user"])
  if err != nil {
      http.Error(w, err.String(), http.StatusInternalServerError)
      return
  }

  if checkPermission() {
      http.Error(w, err.String(), http.StatusUnauthorized)
      return
  }
})
```

Wouldn't it be better to just return the error directly? like so.

```go
GET("/path/to/handle", func(w Response, r Request) ???? {
  actor := current_user(r)
  vars := mux.Vars(r)

  user, err := queryForUser(vars["user"])
  if err != nil {
    return InternalServerError(err)
  }

  if checkPermission() {
    return Unauthorized(err)
  }

  return render("something here")
})
```

But the `http.HandlerFunc` signature doesn't have a return type. so I need to define my own `HandlerFunc` that's slightly different.

What the function returns should be able to take the request and response writer and do some logic. soooo it should return a function with this signature
```go
func(http.ResponseWriter, r *http.Request)
```

Which is exactly the `http.HandlerFunc` signature. so our handler should look like so

```go
GET("/path/to/handle", func(w Response, r Request) http.HandlerFunc {
  actor := current_user(r)
  vars := mux.Vars(r)

  user, err := queryForUser(vars["user"])
  if err != nil {
      return InternalServerError(err)
  }

  if checkPermission() {
      return Unauthorized(err)
  }

  return render("something here")
})
```

To make it more readable I aliased this type to `Output` so the handler will look like so

```go
type Output = http.HandlerFunc // in common.go

// in main func
GET("/path/to/handle", func(w Response, r Request) Output {
  actor := current_user(r)
  vars := mux.Vars(r)

  user, err := queryForUser(vars["user"])
  if err != nil {
      return InternalServerError(err)
  }

  if checkPermission() {
      return Unauthorized(err)
  }

  return render("something here")
})
```

And what `InternalServerError` returns is `Output` type. So now I need a function that takes this handler and then calls the Output with `w` and `req`

```go
func InternalServerError(err error) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}
func Unauthorized(w http.ResponseWriter, r *http.Request) {
	http.Error(w, "", http.StatusUnauthorized)
}
```

And using the same pattern you can define all HTTP statuses as functions. And it also works if you want to redirect the user

```go
func Redirect(url string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		http.Redirect(w, r, url, http.StatusFound)
	}
}
```

Your handler can use it like so

```go
GET("/path/to/handle", func(w Response, r Request) Output {
  actor := current_user(r)
  vars := mux.Vars(r)

  if checkPermission() {
      return Redirect("/unauthorized.html")
  }

  return render("something here")

})
```

# Render views

- I save all views under `views` directory as `.html` files
- Embed them in a FS variable
- in the `init` function it walks the tree of files and parses them using `html/template` package
- every file is defined with template name equals it's relative path to `views` so `views/layout.html` is a template called `layout`
- created a function `partial` that renders a template to string
- then a function `Render` that returns a `http.HandlerFunc` that renders the view and the layout with the parameters passed to it


```go
//go:embed views
var views embed.FS
var templates *template.Template
var helpers = template.FuncMap{}

func compileViews() {
	templates = template.New("")
	fs.WalkDir(views, ".", func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}

		if strings.HasSuffix(path, VIEWS_EXTENSION) && d.Type().IsRegular() {
			name := strings.TrimPrefix(path, "views/")
			name = strings.TrimSuffix(name, VIEWS_EXTENSION)
			log.Printf("Parsing view: %s", name)

			c, err := fs.ReadFile(views, path)
			if err != nil {
				return err
			}

			template.Must(templates.New(name).Funcs(helpers).Parse(string(c)))
		}

		return nil
	})
}

func partial(path string, data interface{}) string {
	v := templates.Lookup(path)
	if v == nil {
		return "view %s not found"
	}

	w := bytes.NewBufferString("")
	err := v.Execute(w, data)
	if err != nil {
		return "rendering error " + path + " " + err.Error()
	}

	return w.String()
}

func Render(path string, view string, data map[string]interface{}) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		data["view"] = view
		fmt.Fprint(w, partial(path, data))
	}
}
```

So now I can have a handler that will render a `privacy` view with `layout` layout around it using the following code

```go
GET("/privacy", func(w Response, r Request) Output {
    return Render("layout", "privacy", map[string]interface{}{
        "current_user": current_user(r),
        "csrf":         csrf.TemplateField(r),
    })
})
```

I didn't like the `map[string]interface{}` part sooooooo. I defined it as a type in `common.go`

```go
type Locals map[string]interface{}
```

So now it's cleaner

```go
GET("/privacy", func(w Response, r Request) Output {
    return Render("layout", "privacy", Locals{
        "current_user": current_user(r),
        "csrf":         csrf.TemplateField(r),
    })
})
```

# Helpers

defining views helpers for `html/template` has a problem to it. You can't parse templates THEN define functions. the functions map is part of the parsing method. because it validates that views are using existing functions and panics in case a function is used incorrectly in a view/template.

So I have to :

- define global variable `helpers = var helpers = template.FuncMap{}` in `common.go`
- in my main I can add any function I want to `helpers` map
- then call `Start()` which will compile and templates with `helpers` map.

# Other conveniences

I need to have middlewares that can be executed before handlers to check for session validation for example. so I made the `GET`, `POST`, `DELETE` variant methods. taking a list of middlewares as last arguments so when I'm defining a handler I can pass couple functions like `loggedinOnly` which checks for current user session.


I also wanted to have CSRF protection. so I used Gorilla CSRF and added it as a default middleware to the server.

Also I needed database connection so I used [SQLC](https://sqlc.dev/) to generate code from SQL queries and instantiated the database connection in `common.go` from environment variable. assigned the `Queries` instance to `queries` global variable. so I can access it from any part of the `main` function.

While I'm at it I also added a logger to the database connection and the server to check what's going on there.

Also I needed to server static files form `public` so I added a handler to the server that server files from this directory.

# Show me the full code

On github you'll find all the common code [here](https://github.com/emad-elsaid/library/blob/bb8720818bfa5600859528da044c7b67cb6b12a9/common.go)


I compared the main file from sinatra to the main file after conversion to go and I found it's around 3 times longer. one main pattern that caused this length is how I can check and return at the same time in go

```ruby
return something if userunauhorized(current_user)
```

In Go
```go
if err!=nil {
  return Unauthorized
}
```

Also I didn't use activerecord so alot of the work activerecord models where doing is now part of the database `ON DELETE` trigger or part of the handler itself.

The following is [the original sinatra code](https://github.com/emad-elsaid/library/tree/6171f903af0f7d80c0e4eb71ed5f7c2ff2e7abd7?fbclid=IwAR3ondJGljsjr-Wc-hkM9KOgcT7fJ5o_6XCpBg3tVRLmbKWg81E4BgKLaeo) And this is when it was [converted to Go](https://github.com/emad-elsaid/library/tree/bb8720818bfa5600859528da044c7b67cb6b12a9)
