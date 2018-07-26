

file(GLOB_RECURSE SRCS *.cpp)

set(BOOST_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../thirdparty/boost/")

set(Boost_USE_STATIC_LIBS        ON) # only find static libs
set(Boost_USE_MULTITHREADED      ON)
set(Boost_USE_STATIC_RUNTIME     ON)

find_package(Boost COMPONENTS system)

if(NOT Boost_FOUND)
    message(FATAL_ERROR "Failed to find boost at " ${Boost_Lib_Dirs} " Need system thread")
endif()

include_directories(${CMAKE_SOURCE_DIR})

message(STATUS "Boost lib dirs: ${Boost_LIBRARY_DIRS}")
link_directories(${Boost_LIBRARY_DIRS})

add_executable(frontend_cryptoTools  ${SRCS})
target_link_libraries(frontend_cryptoTools cryptoTools tests_cryptoTools)
