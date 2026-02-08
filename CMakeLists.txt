cmake_minimum_required(VERSION 3.22)
project(Observer_Testbed LANGUAGES CXX)

if(NOT CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    message(WARNING "Recommended to use Clang for this HFT testbed. Current: ${CMAKE_CXX_COMPILER_ID}")
elseif(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "18.0")
    message(WARNING "Clang 18+ is recommended for optimal optimization. Current: ${CMAKE_CXX_COMPILER_VERSION}")
endif()

set(EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(COMMON_FLAGS "-Wall -Wextra -Wpedantic -march=native")
set(DEBUG_FLAGS "-g -fsanitize=address -fno-omit-frame-pointer")
set(RELEASE_FLAGS "-O3 -flto=thin -fno-signed-zeros")

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${COMMON_FLAGS} ${DEBUG_FLAGS}")
else()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${COMMON_FLAGS} ${RELEASE_FLAGS}")
endif()

add_executable(observer_test main.cpp)

target_compile_options(observer_test PRIVATE -stdlib=libc++)
target_link_options(observer_test PRIVATE -stdlib=libc++ -fuse-ld=lld)