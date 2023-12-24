local Job = require("plenary.job")

local module = {}

module.fetch_job = Job:new({
    command = "git",
    cwd = vim.fn.stdpath("config"),
    args = {
        "fetch",
        "origin",
    },
})

module.behind_job = Job:new({
    command = "git",
    cwd = vim.fn.stdpath("config"),
    args = {
        "rev-list",
        "HEAD..origin/main",
        "--count",
    },
})

module.ahead_job = Job:new({
    command = "git",
    cwd = vim.fn.stdpath("config"),
    args = {
        "rev-list",
        "origin/main..HEAD",
        "--count",
    },
})

module.status_job = Job:new({
    command = "git",
    cwd = vim.fn.stdpath("config"),
    args = {
        "status",
        "--short",
    },
})

module.fetch_job:and_then(module.behind_job)
module.behind_job:and_then(module.ahead_job)
module.ahead_job:and_then(module.status_job)

function module.sync(self)
    self.fetch_job:sync()
end

function module.start(self)
    self.fetch_job:start()
end

function module.wait(self)
    self.behind_job:wait()
    self.ahead_job:wait()
    self.status_job:wait()
end

function module.result(self)
    return {
        ahead = self.ahead_job:result()[1],
        behind = self.behind_job:result()[1],
        has_uncommitted = #self.status_job:result() > 0,
    }
end

function module.after(self, fn)
    self.status_job:after(fn)
end

return module
