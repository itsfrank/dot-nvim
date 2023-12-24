local iter = require("frank.utils.iter")

local function check_eq(a, b, message)
    assert(a == b, vim.inspect(a) .. " ~= " .. vim.inspect(b) .. (message == nil and "" or message))
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

-- run tests
test_zip()
test_filter()
test_fold()
test_map()
test_chain()

print("passed")
