# HipifyPackaging.cmake - centralize CPACK configuration to use ROCM_VERSION
include_guard()

# User-provided ROCm version, e.g. -DROCM_VERSION=8.0.0
set(ROCM_VERSION "" CACHE STRING "ROCm version used for HIPIFY packaging (e.g., 8.0.0). If empty, falls back to PROJECT_VERSION.")

# Validate ROCM_VERSION format x.y[.z]
set(_hipify_pkg_version "${ROCM_VERSION}")
if(_hipify_pkg_version)
  string(REGEX MATCH "^([0-9]+)\\.([0-9]+)(\\.([0-9]+))?$" _hipify_ver_match "${_hipify_pkg_version}")
  if(NOT _hipify_ver_match)
    message(FATAL_ERROR "Invalid ROCM_VERSION '${ROCM_VERSION}'. Expected format: MAJOR.MINOR[.PATCH], e.g., 8.0.0")
  endif()
else()
  # Fallback: use PROJECT_VERSION if defined; otherwise default to 0.0.0
  if(DEFINED PROJECT_VERSION AND PROJECT_VERSION)
    set(_hipify_pkg_version "${PROJECT_VERSION}")
  else()
    set(_hipify_pkg_version "0.0.0")
    message(WARNING "ROCM_VERSION not set and PROJECT_VERSION not defined; defaulting CPACK package version to ${_hipify_pkg_version}")
  endif()
endif()

set(CPACK_PACKAGE_NAME "HIPIFY")
set(CPACK_PACKAGE_VENDOR "ROCm")
set(CPACK_PACKAGE_VERSION "${_hipify_pkg_version}")

# Derive MAJOR/MINOR/PATCH for CPACK from version string
string(REPLACE "." ";" _hipify_ver_list "${CPACK_PACKAGE_VERSION}")
list(GET _hipify_ver_list 0 CPACK_PACKAGE_VERSION_MAJOR)
list(GET _hipify_ver_list 1 CPACK_PACKAGE_VERSION_MINOR)
list(LENGTH _hipify_ver_list _hipify_ver_len)
if(_hipify_ver_len GREATER 2)
  list(GET _hipify_ver_list 2 CPACK_PACKAGE_VERSION_PATCH)
else()
  set(CPACK_PACKAGE_VERSION_PATCH 0)
endif()

# Compose file name with OS and arch for clarity
set(CPACK_SYSTEM_NAME "${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}")
string(TOLOWER "${CPACK_SYSTEM_NAME}" CPACK_SYSTEM_NAME)
set(CPACK_PACKAGE_FILE_NAME "hipify-${CPACK_PACKAGE_VERSION}-${CPACK_SYSTEM_NAME}")

# Common generator defaults
set(CPACK_GENERATOR "TGZ;ZIP")
include(CPack)
