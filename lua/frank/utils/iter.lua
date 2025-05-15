local iter = {}

---Execute predicate on all elements
---@generic T
---@param list T[]
---@param p fun(v:T):nil
function iter.for_each(list, p)
    for _, v in ipairs(list) do
        p(v)
    end
end

---Join two lists into a list of 2-value lists
---List will have length of first list passed in
---If second list is shorter, pairs of {v, nil} are created
---@generic T, U
---@param list T[]
---@param other U[]
---@return {[1]: T, [2]: U}[]
function iter.zip(list, other)
    local zipped = {}
    for i, v in ipairs(list) do
        if i <= #other then
            table.insert(zipped, { v, other[i] })
        else
            table.insert(zipped, { v, nil })
        end
    end
    return zipped
end

---Filter a list
---@generic T
---@param list table<number, T>
---@param p fun(v:T):boolean
---@return table<any, T>
function iter.filter(list, p)
    local filtered = {}
    for _, v in ipairs(list) do
        if p(v) then
            table.insert(filtered, v)
        end
    end
    return filtered
end

---Map values in a list
---@generic T, U
---@param list T[]
---@param p fun(v:T):U
---@return U[]
function iter.map(list, p)
    local mapped = {}
    for _, v in ipairs(list) do
        table.insert(mapped, p(v))
    end
    return mapped
end

---Fold (reduce) values in list
---@generic T
---@param list T[]
---@param p fun(acc:T, v:T):T
---@return T
function iter.fold(list, acc_init, p)
    local acc = acc_init
    for _, v in ipairs(list) do
        acc = p(acc, v)
    end
    return acc
end

---Monad for chaining iter functions
function iter.chain(v)
    local wrapped = {
        _value = v,
    }
    setmetatable(wrapped, {
        __index = function(self, k)
            if k == "get" then
                return function()
                    return self._value
                end
            end

            return function(...)
                local fn = iter[k]
                return iter.chain(fn(self._value, ...))
            end
        end,
    })
    return wrapped
end

-- table versions

iter.tbl = {}

--- Execute predicate on all elements
---@generic K, V
---@param t table<K, V>
---@param p fun(k:K, v:V):nil
function iter.tbl.for_each(t, p)
    for k, v in pairs(t) do
        p(k, v)
    end
end

---Filter a table
---@generic K, V
---@param t table<K, V>
---@param p fun(k:K, v:V):boolean
---@return table<K, V>
function iter.tbl.filter(t, p)
    local filtered = {}
    for k, v in pairs(t) do
        if p(k, v) then
            filtered[k] = v
        end
    end
    return filtered
end

---Map values in a table
---@generic K_in, V_in, K_out, V_out
---@param t table<K_in, V_out>
---@param p fun(k:K_in, v:V_out):K_out, V_out
---@return table<K_out, V_out>
function iter.tbl.map(t, p)
    local mapped = {}
    for k, v in pairs(t) do
        local k_out, v_out = p(k, v)
        mapped[k_out] = v_out
    end
    return mapped
end

---Map values in a table to a list
---@generic K_in, V_in, V_out
---@param t table<K_in, V_out>
---@param p fun(k:K_in, v:V_out):V_out?
---@return V_out[]
function iter.tbl.map_list(t, p)
    local mapped = {}
    for k, v in pairs(t) do
        local v_out = p(k, v)
        if v_out ~= nil then
            table.insert(mapped, v_out)
        end
    end
    return mapped
end

---Table keys as list
---@generic K, V
---@param t table<K, V>
---@return K[]
function iter.tbl.keys(t)
    return iter.tbl.map_list(t, function(k, _)
        return k
    end)
end

---Table values as list
---@generic K, V
---@param t table<K, V>
---@return V[]
function iter.tbl.values(t)
    return iter.tbl.map_list(t, function(_, v)
        return v
    end)
end

-- fold

return iter
