file(GLOB SRCS *.cpp)
link_directories(${Boost_LIBRARY_DIRS})

add_library(testsVS_cryptoTools SHARED ${SRCS})
target_link_libraries(testsVS_cryptoTools tests_cryptoTools cryptoTools)
