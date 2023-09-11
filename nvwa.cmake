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

git_clone(https://raw.githubusercontent.com/kautils/CMakeLibrarytemplate/v0.0.1/CMakeLibrarytemplate.cmake)
git_clone(https://raw.githubusercontent.com/kautils/CMakeFetchKautilModule/v0.0.1/CMakeFetchKautilModule.cmake)


if(DEFINED CACHE{mman.INSTALL_PREFIX})
    if(NOT EXISTS ${mman.INSTALL_PREFIX}/lib/libmman.a
       OR NOT EXISTS ${mman.INSTALL_PREFIX}/include/sys/mman.h)
        set(${PROJECT_NAME}_FORCE FORCE_BUILD)
    endif()
else()
    set(${PROJECT_NAME}_FORCE FORCE_UPDATE)
endif()
CMakeFetchKautilModule(mman GIT https://github.com/alitrack/mman-win32.git REMOTE origin HASH 2d1c576e62b99e85d99407e1a88794c6e44c3310 
        DESTINATION "${CMAKE_CURRENT_BINARY_DIR}"
        CMAKE_CONFIGURE_MACRO -DBUILD_SHARED_LIBS=OFF
        ${${PROJECT_NAME}_FORCE}
        )

CMakeGitCloneMinimal(nvwa 
        REPOSITORY_REMOTE origin  
        REPOSITORY_URI https://github.com/adah1972/nvwa.git  
        DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}
        HASH 1163b3809ef6cf54853d7ee2b346baf652049341 
        )
set(module_name nvwa)
unset(srcs)
file(GLOB srcs ${nvwa}/nvwa/*.cpp)

set(${module_name}_common_pref
    #DEBUG_VERBOSE
    MODULE_PREFIX kautil debug 
    MODULE_NAME ${module_name}
    INCLUDES ${nvwa}/nvwa $<BUILD_INTERFACE:${nvwa}/nvwa> $<INSTALL_INTERFACE:include>  
    SOURCES ${srcs}
#    LINK_LIBS 
    EXPORT_NAME_PREFIX ${PROJECT_NAME}
    EXPORT_VERSION ${PROJECT_VERSION}
    EXPORT_VERSION_COMPATIBILITY AnyNewerVersion
    DESTINATION_INCLUDE_DIR include/nvwa
    DESTINATION_CMAKE_DIR cmake
    DESTINATION_LIB_DIR lib
)


CMakeLibraryTemplate(${module_name} EXPORT_LIB_TYPE static ${${module_name}_common_pref} )
# to avoid adding link-directory and using lmman. if do so, cmake will add INTERFACE_INCLUDE_DIRECTORIES auto matically, then target in the same bubild interface will fail 
# first i erased that implicitly added property like below. i not sure which is better.
target_link_libraries(${${module_name}_static} PRIVATE "${mman.INSTALL_PREFIX}/lib/libmman.a")
target_include_directories(${${module_name}_static} PRIVATE "${mman.INSTALL_PREFIX}/include")
set_target_properties(kautil_debug_nvwa_0.0.1_static PROPERTIES INTERFACE_LINK_LIBRARIES "")


foreach(__var ${${PROJECT_NAME}_unsetter})
    unset(__var)
endforeach()



set(__lib_type static)
set(__t ${nvwa_${__lib_type}_tmain})
add_executable(${__t})
target_sources(${__t} PRIVATE ${CMAKE_CURRENT_LIST_DIR}/unit_test.cc)
target_link_libraries(${__t} PRIVATE ${nvwa_${__lib_type}})
target_compile_definitions(${__t} PRIVATE ${nvwa_${__lib_type}_tmain_ppcs})


