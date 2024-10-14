cmake_minimum_required(VERSION 3.27)

project({{cookiecutter.program_name}}
    VERSION 0.0.0
    LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRE True)

# Always produce compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS True)

# add_compile_options(-Wall -Wextra -pedantic -Wshadow -Wconversion -Wcast-align -Weffc++)
add_compile_options(-Wall -Wextra -pedantic -Wcast-align)
add_compile_options("$<$<CONFIG:RELEASE>:-flto=auto>")
add_compile_options("$<$<CONFIG:DEBUG>:-Og;-g;-fno-omit-frame-pointer;-fsanitize=undefined,address>")
add_link_options("$<$<CONFIG:RELEASE>:-flto=auto>")
add_link_options("$<$<CONFIG:DEBUG>:-fsanitize=undefined,address>")

# Configure usage of pkgconfig
find_package(PkgConfig REQUIRED)

# Add libfmt
pkg_check_modules(FMT fmt REQUIRED)

add_executable({{cookiecutter.program_name}} src/main.cpp)

target_include_directories({{cookiecutter.program_name}} PUBLIC
    ${FMT_INCLUDE_DIRS}
)
target_link_libraries({{cookiecutter.program_name}} 
    ${FMT_LIBRARIES}
)
target_compile_options({{cookiecutter.program_name}} PUBLIC
    ${FMT_CFLAGS_OTHER}
)

