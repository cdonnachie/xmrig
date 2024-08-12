if (WITH_MERAKI)
    add_definitions(/DXMRIG_ALGO_MERAKI)

    list(APPEND HEADERS_CRYPTO
        src/crypto/meraki/MKCache.h
        src/crypto/meraki/MKHash.h
    )

    list(APPEND SOURCES_CRYPTO
        src/crypto/meraki/MKCache.cpp
        src/crypto/meraki/MKHash.cpp
    )

    if(!WITH_KAWPOW AND !WITH_MEOWPOW AND !WITH_EVRPROGPOW)
        add_subdirectory(src/3rdparty/libethash)
        set(ETHASH_LIBRARY ethash)
    endif()
else()
    remove_definitions(/DXMRIG_ALGO_MERAKI)
    if(!WITH_KAWPOW AND !WITH_MEOWPOW AND !WITH_EVRPROGPOW)
        set(ETHASH_LIBRARY "")
    endif()
endif()
