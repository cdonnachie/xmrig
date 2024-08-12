if (WITH_MEOWPOW)
    add_definitions(/DXMRIG_ALGO_MEOWPOW)

    list(APPEND HEADERS_CRYPTO
        src/crypto/meowpow/MPCache.h
        src/crypto/meowpow/MPHash.h
    )

    list(APPEND SOURCES_CRYPTO
        src/crypto/meowpow/MPCache.cpp
        src/crypto/meowpow/MPHash.cpp
    )

    if(!WITH_KAWPOW AND !WITH_EVRPROGPOW AND !WITH_MERAKI)
        add_subdirectory(src/3rdparty/libethash)
        set(ETHASH_LIBRARY ethash)
    endif()
else()
    remove_definitions(/DXMRIG_ALGO_MEOWPOW)
    if(!WITH_KAWPOW AND !WITH_EVRPROGPOW AND !WITH_MERAKI)
        set(ETHASH_LIBRARY "")
    endif()
endif()
