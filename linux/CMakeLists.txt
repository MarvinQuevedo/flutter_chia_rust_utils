set(LibraryVersion "flutter_chia_rust_utils-v0.0.62+2") # generated; do not edit
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

# Project-level configuration.
set(PROJECT_NAME "flutter_chia_rust_utils")
project(${PROJECT_NAME} LANGUAGES CXX)

# This value is used when generating builds using this plugin, so it must
# not be changed.
set(PLUGIN_NAME "flutter_chia_rust_utils_plugin")

# Define the plugin library target. Its name must not be changed (see comment
# on PLUGIN_NAME above).
#
# Any new source files that you add to the plugin should be added here.
add_library(${PLUGIN_NAME} SHARED
  "flutter_chia_rust_utils_plugin.cc"
)

# Apply a standard set of build settings that are configured in the
# application-level CMakeLists.txt. This can be removed for plugins that want
# full control over build settings.
apply_standard_settings(${PLUGIN_NAME})

# Symbols are hidden by default to reduce the chance of accidental conflicts
# between plugins. This should not be removed; any symbols that should be
# exported should be explicitly exported with the FLUTTER_PLUGIN_EXPORT macro.
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)

# Source include directories and library dependencies. Add any plugin-specific
# dependencies here.
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::GTK)

# Define the Rust library path
set(RUST_LIB_NAME "librust_bls_flutter.so")
set(RUST_LIB_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${RUST_LIB_NAME}")

# Check if Rust library exists, if not try to download/extract it
if(NOT EXISTS ${RUST_LIB_PATH})
  set(LibRoot "${CMAKE_CURRENT_SOURCE_DIR}/${LibraryVersion}")
  set(ArchivePath "${LibRoot}.tar.gz")
  
  if(EXISTS ${ArchivePath})
    message(STATUS "Extracting Rust library from ${ArchivePath}")
    execute_process(
      COMMAND ${CMAKE_COMMAND} -E tar xzf ${ArchivePath}
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      RESULT_VARIABLE TAR_RESULT
    )
    if(TAR_RESULT EQUAL 0)
      # Find the extracted library and copy it to the expected location
      file(GLOB_RECURSE EXTRACTED_LIB "${CMAKE_CURRENT_SOURCE_DIR}/linux-*/${RUST_LIB_NAME}")
      if(EXTRACTED_LIB)
        list(GET EXTRACTED_LIB 0 FIRST_LIB)
        file(COPY ${FIRST_LIB} DESTINATION ${CMAKE_CURRENT_SOURCE_DIR})
        message(STATUS "Copied Rust library to ${RUST_LIB_PATH}")
      endif()
    endif()
  else()
    message(WARNING "Rust library not found and no archive available. Please build the Rust library first using: ./scripts/build-linux-in-linux.sh")
  endif()
endif()

# List of absolute paths to libraries that should be bundled with the plugin.
# This list should contain the Rust library that needs to be distributed with the app.
set(flutter_chia_rust_utils_bundled_libraries
  "${RUST_LIB_PATH}"
  PARENT_SCOPE
)

# Custom target to build Rust library if needed
add_custom_target(build_rust_lib
  COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/../scripts/build-linux-in-linux.sh
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/..
  COMMENT "Building Rust library for Linux"
)

# Make the plugin depend on the Rust library build
add_dependencies(${PLUGIN_NAME} build_rust_lib)