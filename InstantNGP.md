#AI 

+ Repo https://github.com/NVlabs/instant-ngp
+ Install script
```bash
sudo pacman -S cuda base-devel cmake openexr libxi glfw openmp libxinerama libxcursor
```

+ The command was missing one package `glew` that caused an error in the build command
```bash
Could NOT find GLEW (missing: GLEW_INCLUDE_DIRS GLEW_LIBRARIES)
```

+ Clone and build
```bash
git clone --recursive https://github.com/nvlabs/instant-ngp
cd instant-ngp
cmake . -B build
cmake --build build --config RelWithDebInfo -j
```

+ I noticed that the machine froze when running the last command.