cmake_minimum_required (VERSION 2.8)

project(cryptoTools)

if("${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")

	############################################
	#          If top level cmake              #
	############################################

	set( CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_HOME_DIRECTORY}/bin)
	set( CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_HOME_DIRECTORY}/lib)
	set( CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_HOME_DIRECTORY}/lib)

	if(CMAKE_COMPILER_IS_GNUCXX)
		set(CMAKE_C_FLAGS "-ffunction-sections -Wall  -maes -msse2 -msse4.1 -mpclmul -Wfatal-errors -pthread -fPIC -Wno-ignored-attributes")
	endif(CMAKE_COMPILER_IS_GNUCXX)
	if(MSVC)
		ADD_DEFINITIONS(/arch:AVX2)
		ADD_DEFINITIONS(/EHsc)
		ADD_DEFINITIONS(-D_WIN32_WINNT=0x0601)
		ADD_DEFINITIONS(/MT)
	endif(MSVC)
	set(CMAKE_CXX_FLAGS  "${CMAKE_C_FLAGS}  -std=c++14")

	
	# Set a default build type for single-configuration
	# CMake generators if no build type is set.
	if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
	   SET(CMAKE_BUILD_TYPE Release)
	endif()

	if(NOT ${CMAKE_BUILD_TYPE} STREQUAL "Release")
	  message(WARNING "\nConfiguration NOT set to Release. Please call cmake with -DCMAKE_BUILD_TYPE=Release  instead of ${CMAKE_BUILD_TYPE}")

		if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
		  #message(WARNING "Debug build.")
		elseif("${CMAKE_BUILD_TYPE}" STREQUAL "Release") 
		  #message(WARNING "Release build.")
		elseif("${CMAKE_BUILD_TYPE}" STREQUAL  "RELWITHDEBINFO")
		  #message(WARNING "RELWITHDEBINFO=Release with debug info build.")
		else()
		  message(ERROR ": Unknown build type - ${CMAKE_BUILD_TYPE}  Please use one of Debug, Release, or RELWITHDEBINFO\n\n" )
		endif()
	endif()

	# Select flags.
	if(CMAKE_COMPILER_IS_GNUCXX)
		SET(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG") 	
		SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO " -O2 -g -ggdb -rdynamic")
		SET(CMAKE_CXX_FLAGS_DEBUG  "-O0 -g -ggdb -rdynamic")
	endif(CMAKE_COMPILER_IS_GNUCXX)
	if(MSVC)
		SET(CMAKE_CXX_FLAGS_RELEASE "-O2") 	
		SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO " -O2 -Zi")
		SET(CMAKE_CXX_FLAGS_DEBUG  "-Od -Zi")
	endif(MSVC)
endif() 

## Boost
###########################################################################
# Find Boost library. The Boost path is used in several subdirectories.

set(BOOST_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/boost/")

set(Boost_USE_STATIC_LIBS        ON) # only find static libs
set(Boost_USE_MULTITHREADED      ON)
set(Boost_USE_STATIC_RUNTIME     ON)

find_package(Boost COMPONENTS system thread)

if(NOT Boost_FOUND)
    message(FATAL_ERROR "Failed to find boost at " ${Boost_Lib_Dirs} " Need system thread")
endif()

IF(INSTALL_BOOST)
    INSTALL(DIRECTORY "${Boost_INCLUDE_DIR}/boost" DESTINATION include)
    INSTALL(FILES ${Boost_LIBRARIES} DESTINATION lib)
ENDIF(INSTALL_BOOST)

message(STATUS "Boost_include  ${Boost_INCLUDE_DIR}" )

#############################################
#       cryptoTools, tests, frontend        #
#############################################
include_directories(${CMAKE_CURRENT_SOURCE_DIR}) 


add_subdirectory(cryptoTools)
add_subdirectory(tests_cryptoTools)
if (MSVC)
	add_subdirectory(testsVS_cryptoTools)
endif(MSVC)
add_subdirectory(frontend_cryptoTools)

install(FILES cryptotools-config.cmake DESTINATION cmake/)
