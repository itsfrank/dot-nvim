local Job = require('plenary.job')

local module = {}
module.fetch_job = Job:new({
    command = 'git',
    args = {
        'fetch',
        'origin',
    }
})

module.behind_job = Job:new({
    command = 'git',
    args = {
        'rev-list',
        'HEAD..origin/main',
        '--count',
    },
})

module.ahead_job = Job:new({
    command = 'git',
    args = {
        'rev-list',
        'HEAD..origin/main',
        '--count',
    },
})

module.fetch_job:and_then(module.behind_job)
module.fetch_job:and_then(module.ahead_job)

function module.sync(self)
    self.fetch_job:sync()
end

function module.start(self)
    self.fetch_job:start()
end

function module.wait(self)
    self.behind_job:wait()
    self.ahead_job:wait()
end

function module.result(self)
    return {
        ahead = self.ahead_job:result()[1],
        behind = self.behind_job:result()[1],
    }
end

return module
