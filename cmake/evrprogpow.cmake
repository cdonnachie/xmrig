if (WITH_EVRPROGPOW)
    add_definitions(/DXMRIG_ALGO_EVRPROGPOW)

    list(APPEND HEADERS_CRYPTO
        src/crypto/evrprogpow/EPPCache.h
        src/crypto/evrprogpow/EPPHash.h
    )

    list(APPEND SOURCES_CRYPTO
        src/crypto/evrprogpow/EPPCache.cpp
        src/crypto/evrprogpow/EPPHash.cpp
    )

    if(!WITH_KAWPOW AND !WITH_MEOWPOW AND !WITH_MERAKI)
        add_subdirectory(src/3rdparty/libethash)
        set(ETHASH_LIBRARY ethash)
    endif()
else()
    remove_definitions(/DXMRIG_ALGO_EVRPROGPOW)
    if(!WITH_KAWPOW AND !WITH_MEOWPOW AND !WITH_MERAKI)
        set(ETHASH_LIBRARY "")
    endif()
endif()
