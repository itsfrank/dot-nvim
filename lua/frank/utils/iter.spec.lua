local iter = require("frank.utils.iter")

local function check_eq(a, b, message)
    assert(a == b, vim.inspect(a) .. " ~= " .. vim.inspect(b) .. (message == nil and "" or message))
end

local function check_tbl_eq(a, b, message)
    local equal = true
    for k, v in pairs(a) do
        if b[k] ~= v then
            equal = false
        end
    end
    for k, v in pairs(b) do
        if a[k] ~= v then
            equal = false
        end
    end
    assert(equal, vim.inspect(a) .. " ~= " .. vim.inspect(b) .. (message == nil and "" or message))
end

local function test_zip()
    local input_a = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }
    local input_b = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

    for i, pair in ipairs(iter.zip(input_a, input_b)) do
        check_eq(input_a[i], pair[1])
        check_eq(input_b[i], pair[2])
    end
end

local function test_filter()
    local input = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }
    local exp = { 3, 4, 5 }
    local got = iter.filter(input, function(v)
        return v >= 3 and v <= 5
    end)
    iter.chain(iter.zip(exp, got)).for_each(function(v)
        check_eq(v[1], v[2])
    end)
end

local function test_fold()
    local input = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }
    local exp = 45
    local got = iter.fold(input, 0, function(acc, v)
        return acc + v
    end)
    check_eq(exp, got)
end

local function test_map()
    local input = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }
    local exp = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
    local got = iter.map(input, function(v)
        return tostring(v)
    end)
    iter.chain(iter.zip(exp, got)).for_each(function(v)
        check_eq(v[1], v[2])
    end)
end

local function test_chain()
    local input = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }
    local exp = 40
    local got = iter.chain(input)
        .filter(function(v)
            return v % 2 == 0
        end)
        .map(function(v)
            return v * 2
        end)
        .fold(0, function(acc, v)
            return acc + v
        end)
        .get()
    check_eq(exp, got)
end

local function test_tbl_map()
    local input = {
        a = 1,
        b = 2,
        c = 3,
    }
    local exp = {
        a = "1",
        b = "2",
        c = "3",
    }
    local got = iter.tbl.map(input, function(k, v)
        return k, tostring(v)
    end)
    check_tbl_eq(exp, got)
end

local function test_tbl_map_list()
    local input = {
        a = 1,
        b = 2,
        c = 3,
    }
    local exp = { "a1", "b2", "c3" }
    local got = iter.tbl.map_list(input, function(k, v)
        return k .. tostring(v)
    end)
    check_tbl_eq(exp, got)
end

-- run tests
test_zip()
test_filter()
test_fold()
test_map()
test_chain()
test_tbl_map()
test_tbl_map_list()

print("passed")
