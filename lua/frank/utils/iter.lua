local iter = {}

---Execute predicate on all elements
---@generic T
---@param list T[]
---@param p fun(T):nil
function iter.for_each(list, p)
	for _, v in ipairs(list) do
		p(v)
	end
end

---Join two lists into a list of 2-value lists
---List will have length of first list passed in
---If second list is shorter, pairs of {v, nil} are created
---@generic T
---@generic U
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
---@param list T[]
---@param p fun(T):boolean
---@return T[]
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
---@generic T
---@generic U
---@param list T[]
---@param p fun(T):U
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
---@param p fun(T, T):T fun(acc, value)
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

return iter
