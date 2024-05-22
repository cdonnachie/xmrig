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

    if(!WITH_KAWPOW)
        add_subdirectory(src/3rdparty/libethash)
        set(ETHASH_LIBRARY ethash)
    endif()
else()
    if(!WITH_KAWPOW)
        remove_definitions(/DXMRIG_ALGO_MEOWPOW)
        set(ETHASH_LIBRARY "")
    endif()
endif()
