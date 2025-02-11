// Common

typedef int int32;
typedef unsigned long long uint64;

// Partial declaration with no functions (so we can pass it along)
struct gmval_c {
    uint64 _v;
};

typedef gmval_c (*CronusFunc_c)(gmval_c self, gmval_c callee, int argc, gmval_c* args);

// SharedLibraryManager

extern "C" void* SharedLibraryManager_GetFunctionByIndex(int index);
extern "C" int SharedLibraryManager_GetFunctionIndex(const char* libName, const char* functionName);

// GMVal Coerce

extern "C" double gmval_CoerceReal(gmval_c val);
extern "C" const char* gmval_CoerceCString(gmval_c val);;

// GMVal From

extern "C" gmval_c gmval_FromDouble(double d);
extern "C" gmval_c gmval_FromString(const char* s);

extern "C" gmval_c gmval_undefined();

// RunnerInterface

extern "C" void RunnerInterface_AddFunction(const char* name, CronusFunc_c func, int argc);
extern "C" void RunnerInterface_AddConstant_Double(const char* name, double value);
extern "C" void RunnerInterface_AddConstant_String(const char* name, const char* value);
extern "C" void RunnerInterface_ArgCountError(const char* funcName, int argc, int expected);

#include "execute_shell_simple_ext_Module_Stubs.h"

extern "C" gmval_c __GMLIBSTUB_GMVAL__execute_shell_simple_raw(gmval_c self, gmval_c callee, int argc, gmval_c* args)
{
    if (argc < 4)
        RunnerInterface_ArgCountError("execute_shell_simple_raw", argc, 4);
    // coerce arguments
    const char* arg0;
    const char* arg1;
    const char* arg2;
    double arg3;
    arg0 = gmval_CoerceCString(args[0]);
    arg1 = gmval_CoerceCString(args[1]);
    arg2 = gmval_CoerceCString(args[2]);
    arg3 = gmval_CoerceReal(args[3]);
    // shared library manager block
    using FunctionPtr = double(*)(const char*, const char*, const char*, double);
    static int32 index = SharedLibraryManager_GetFunctionIndex("execute_shell_simple_ext", "execute_shell_simple_raw");
    FunctionPtr execute_shell_simple_raw = (FunctionPtr)SharedLibraryManager_GetFunctionByIndex(index);
    if (execute_shell_simple_raw == nullptr) return gmval_undefined();
    // function call
    double result = execute_shell_simple_raw(arg0, arg1, arg2, arg3);
    return gmval_FromDouble(result);
}
extern "C" void Setup_execute_shell_simple_ext()
{
    RunnerInterface_AddFunction("execute_shell_simple_raw", __GMLIBSTUB_GMVAL__execute_shell_simple_raw, 4);
}
