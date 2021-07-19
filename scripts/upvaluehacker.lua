--Tool designed by Rezecib.
--Personal Changed by Tony.

local function GetUpvalueHelper(fn, name)
    local i = 1
    while debug.getupvalue(fn, i) and debug.getupvalue(fn, i) ~= name do
        i = i + 1
    end
    local name, value = debug.getupvalue(fn, i)
    return value, i
end
 
local function GetUpvalue(fn, path)
    local prv, i, prv_var = nil, nil, nil
    for var in path:gmatch("[^%.]+") do
        prv = fn
        fn, i = GetUpvalueHelper(fn, var)
    end
    return fn, i, prv
end
 
local function SetUpvalue(start_fn, path, new_fn)
    local _fn, _fn_i, scope_fn = GetUpvalue(start_fn, path)
    if not _fn then print("Didn't find "..path.." from", start_fn) return end
    debug.setupvalue(scope_fn, _fn_i, new_fn)
end
 
return {
    GetUpvalue = GetUpvalue,
    SetUpvalue = SetUpvalue
}