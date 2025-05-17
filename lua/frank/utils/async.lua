local async = {}

--- wrap a function with a callback into a blocking synchronous call
---@param f fun(..., callback):nil
---@return fun(...):...
function async.wrap(f)
    return function(...)
        local co = coroutine.running()
        f(..., function(...)
            coroutine.resume(co, ...)
        end)
        return coroutine.yield()
    end
end

--- wrap a function with a callback and execute immediately
---@param f fun(..., callback):nil
---@return fun(...):...
function async.await(f, ...)
    local wrapped = async.wrap(f)
    return wrapped(...)
end

--- immediately execute function in separate coroutine
--- sugar for coroutine.create + coroutine.resume
---@param f fun():nil
function async.block(f)
    local co = coroutine.create(f)
    coroutine.resume(co)
end

return async
