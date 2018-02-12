# 20180212 
# https://github.com/lua/lua 不包含 luac ，自己去找 luac 。
# 对比了 https://github.com/lua/luac  与 https://www.lua.org/ftp/lua-5.3.4.tar.gz 代码一致。

#project (lua c) # error on Windows,  No CMAKE_c_COMPILER could be found.



if (APPLE)
    set(CMAKE_MACOSX_RPATH 0)
endif ()

set(lua_home ${CMAKE_CURRENT_LIST_DIR}/../lua-5.3.4)

set(lua_sources
        ${lua_home}/ltable.h
        ${lua_home}/ltm.h
        ${lua_home}/lua.h
        #${lua_home}/lua.hpp
        ${lua_home}/luaconf.h
        ${lua_home}/lualib.h
        ${lua_home}/lundump.h
        ${lua_home}/lvm.h
        ${lua_home}/lzio.h
        #${lua_home}/Makefile
        ${lua_home}/lapi.c
        ${lua_home}/lauxlib.c
        ${lua_home}/lbaselib.c
        ${lua_home}/lbitlib.c
        ${lua_home}/lcode.c
        ${lua_home}/lcorolib.c
        ${lua_home}/lctype.c
        ${lua_home}/ldblib.c
        ${lua_home}/ldebug.c
        ${lua_home}/ldo.c
        ${lua_home}/ldump.c
        ${lua_home}/lfunc.c
        ${lua_home}/lgc.c
        ${lua_home}/linit.c
        ${lua_home}/liolib.c
        ${lua_home}/llex.c
        ${lua_home}/lmathlib.c
        ${lua_home}/lmem.c
        ${lua_home}/loadlib.c
        ${lua_home}/lobject.c
        ${lua_home}/lopcodes.c
        ${lua_home}/loslib.c
        ${lua_home}/lparser.c
        ${lua_home}/lstate.c
        ${lua_home}/lstring.c
        ${lua_home}/ltable.c
        ${lua_home}/ltablib.c
        ${lua_home}/ltm.c
        #${lua_home}/lua.c
        #${lua_home}/luac.c
        ${lua_home}/lundump.c
        ${lua_home}/lutf8lib.c
        ${lua_home}/lvm.c
        ${lua_home}/lzio.c
        ${lua_home}/lapi.h
        ${lua_home}/lauxlib.h
        ${lua_home}/lcode.h
        ${lua_home}/lctype.h
        ${lua_home}/ldebug.h
        ${lua_home}/ldo.h
        ${lua_home}/lfunc.h
        ${lua_home}/lgc.h
        ${lua_home}/llex.h
        ${lua_home}/llimits.h
        ${lua_home}/lmem.h
        ${lua_home}/lobject.h
        ${lua_home}/lopcodes.h
        ${lua_home}/lparser.h
        ${lua_home}/lprefix.h
        ${lua_home}/lstate.h
        ${lua_home}/lstring.h
        ${lua_home}/lstrlib.c
        )

set(self_lib lua)
add_library (${self_lib} STATIC ${lua_sources})

target_include_directories(${self_lib} PUBLIC ${lua_home})
# other used lua project should include those header files
#target_include_directories(${self_lib} INTERFACE  ${CMAKE_CURRENT_LIST_DIR}/include)
if(WIN32)
    #target_compile_definitions(${PROJECT_NAME} PRIVATE _CRT_SECURE_NO_WARNINGS)
    # lua 5.3.4 has no warning compiled on Visual Studio 2017, no need this any more

    target_compile_options(${self_lib} PRIVATE /source-charset:utf-8 /execution-charset:utf-8)
else()
target_link_libraries(${self_lib} m)
endif()

if (UNIX)
    # for lua/src/loslib.c:111 use mkstemp instead of use tmpnam
    target_compile_definitions(${self_lib} PRIVATE LUA_USE_POSIX)

    # compile error on CentOS release 5.11 (Final)
    # error message is:
    #  error: #error "Compiler does not support 'long long'.
    #  Use option '-DLUA_32BITS'   or '-DLUA_C89_NUMBERS' (see file 'luaconf.h' for details)"
    #target_compile_definitions(${PROJECT_NAME} PRIVATE LUA_C89_NUMBERS)
    # or
    # this is the lua official way in lua's source code makefile
    target_compile_options(${self_lib} PRIVATE "-std=gnu99")

endif()
#target_compile_definitions(${PROJECT_NAME} PRIVATE LUA_COMPAT_5_2)



# 从 GitHub repo 获取的 lua lib 编译有错误
#3>I:\3lua\lsyncd\luac\luac.c(302): warning C4013: “getfuncline”未定义；假设外部返回 int
#3>I:\3lua\lsyncd\luac\luac.c(310): warning C4013: “getBMode”未定义；假设外部返回 int
#3>I:\3lua\lsyncd\luac\luac.c(310): error C2065: “OpArgN”: 未声明的标识符
#3>I:\3lua\lsyncd\luac\luac.c(310): warning C4013: “ISK”未定义；假设外部返回 int
#3>I:\3lua\lsyncd\luac\luac.c(310): warning C4013: “INDEXK”未定义；假设外部返回 int
#3>I:\3lua\lsyncd\luac\luac.c(311): warning C4013: “getCMode”未定义；假设外部返回 int
#3>I:\3lua\lsyncd\luac\luac.c(311): error C2065: “OpArgN”: 未声明的标识符
#3>I:\3lua\lsyncd\luac\luac.c(315): error C2065: “OpArgK”: 未声明的标识符
#3>I:\3lua\lsyncd\luac\luac.c(316): error C2065: “OpArgU”: 未声明的标识符
#3>已完成生成项目“luac.vcxproj”的操作 - 失败。
# 更换回从 lua 官网下载的 https://www.lua.org/ftp/lua-5.3.4.tar.gz 就成功
set(self_luac luac)
add_executable(${self_luac} ${lua_home}/luac.c)
#target_include_directories(${self_luac} PRIVATE ${CMAKE_CURRENT_LIST_DIR}/../lua)
target_link_libraries(${self_luac} lua)
if(NOT WIN32)
target_link_libraries(${self_luac} m)
endif()
set(LUA_COMPILER $<TARGET_FILE:${self_luac}>)



set(self_interpreter lua_run)
add_executable(${self_interpreter} ${lua_home}/lua.c)
target_link_libraries(${self_interpreter} lua)
if(NOT WIN32)
target_link_libraries(${self_interpreter} m)
endif()
set(LUA_EXECUTABLE $<TARGET_FILE:${self_interpreter}>)