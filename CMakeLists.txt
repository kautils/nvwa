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

include("${CMAKE_CURRENT_LIST_DIR}/nvwa.cmake")
