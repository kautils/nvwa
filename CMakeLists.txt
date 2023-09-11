cmake_minimum_required(VERSION 3.20)
set(__version 0.0.1)
project(KautilDebugNvwa.${__version}
        LANGUAGES C CXX
        VERSION ${__version}
        )
unset(__version)

if(NOT ${MINGW})
    message(FATAL_ERROR "this is wrapper of nvwa for mingw.on unix like system it is better to use nvwa directolly.")
endif()


if(NOT DEFINED KAUTIL_THIRD_PARTY_DIR)
    set(KAUTIL_THIRD_PARTY_DIR ${CMAKE_BINARY_DIR})
    file(MAKE_DIRECTORY "${KAUTIL_THIRD_PARTY_DIR}")
endif()

macro(git_clone url)
    get_filename_component(file_name ${url} NAME)
    if(NOT EXISTS ${KAUTIL_THIRD_PARTY_DIR}/kautil_cmake/${file_name})
        file(DOWNLOAD ${url} "${KAUTIL_THIRD_PARTY_DIR}/kautil_cmake/${file_name}")
    endif()
    include("${KAUTIL_THIRD_PARTY_DIR}/kautil_cmake/${file_name}")
    unset(file_name)
endmacro()



git_clone(https://raw.githubusercontent.com/kautils/CMakeLibrarytemplate/v0.0.1/CMakeGitCloneMinimal.cmake)
CMakeGitCloneMinimal( nvwa 
        REPOSITORY_REMOTE origin  
        REPOSITORY_URI https://github.com/adah1972/nvwa.git  
        DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}
        HASH 1163b3809ef6cf54853d7ee2b346baf652049341 
        )
if(NOT EXISTS "${nvwa}/nvwa.cmake")
    file(COPY_FILE "${CMAKE_CURRENT_LIST_DIR}/nvwa.cmake.in" "${nvwa}/nvwa.cmake" )
endif()

include("${CMAKE_CURRENT_LIST_DIR}/nvwa.cmake")

