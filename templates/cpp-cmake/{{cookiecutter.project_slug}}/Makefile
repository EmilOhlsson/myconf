.PHONY: all format clean Debug Release RelWithDebInfo

# Set this to false when building for target hardware
all: Debug
Debug Release RelWithDebInfo:
	cmake -B build -DCMAKE_BUILD_TYPE=$@
	cmake --build build

format:
	clang-format -i src/*.cpp src/*.hpp
