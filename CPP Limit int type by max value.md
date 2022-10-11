For the past couple weeks I have been reviewing #CPP, and while doing so I'm creating a [small Snake game](https://github.com/emad-elsaid/snake)

I started the game without any images at all. everything is a rectangle and then when the game was working I wanted to replace the food rectangle with an image that moves. and found an asset of itch.io with a spinning coin sprite.

The sprite is 5 frames each is 16 pixels. so to draw one of these frames each drawing operation I had to store current frame number and every iteration I increase it and when it goes out of bound I reset it to zero;

```cpp
int frame = 0;
frame = (frame+1) % 5;
```

That makes frame include only the values (0,1,2,3,4). So I wanted to flex a bit and make a type that's an Int that I can increment it and it bounds itself to a max value.

My first attempt was using template.

```cpp
template<int max>
class LimitedInt {
public:
  LimitedInt() : v {0}{};
  operator int() const { return v; };
  LimitedInt<max>& operator++(int) {
    v = (v+1) % max;
    return *this;
  };

private:
  int v;
};

```

this can be used as follows:

```cpp
LimitedInt<5> frame;
frame++;
```

the frame unary (++) operation will increase the int by 1 and reset it when it reaches 5. same behavior. I just can reuse the class multiple times when I need this behavior for another sprite.

But I thought for a while and figured that I don't really need the template at all. I can get away by storing max in the class itself.

```cpp
class LimitedInt {
public:
  LimitedInt(int max) : v {0}, max {max}{};
  operator int() const { return v; };
  LimitedInt& operator++(int) {
    v++;
    v %= max;
    return *this;
  };

private:
  int v;
  int max;
};
```

and it will be used as follows:

```cpp
LimitedInt frame(5);
frame++;
```

And frame can be used as int as I overloaded the `int` operator (that's my TIL).

Here is [the final code](https://github.com/emad-elsaid/snake/blob/6055849962428d4565d43c1caf260c5632ed799f/main.cpp#L24) as part of the snake game
