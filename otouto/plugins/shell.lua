local shell = {}

local utilities = require('otouto.utilities')

function shell:init(config)
    shell.triggers = utilities.triggers(self.info.username, config.cmd_pat):t('run', true).table
end

function shell:action(msg, config)

    if msg.from.id ~= config.admin then
        return
    end

    local input = utilities.input(msg.text)
    input = input:gsub('—', '--')

    if not input then
        utilities.send_reply(msg, 'Please specify a command to run.')
        return
    end

    local f = io.popen(input)
    local output = f:read('*all')
    f:close()
    if output:len() == 0 then
        output = 'Done!'
    else
        output = '```\n' .. output .. '\n```'
    end
    utilities.send_message(msg.chat.id, output, true, msg.message_id, true)

end

return shell
