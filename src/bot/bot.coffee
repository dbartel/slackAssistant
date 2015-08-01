Slack = require 'slack-client'
_ = require 'lodash'


_DEFAULTS =
        token: ""
        autoReconnect: true
        autoMark: true
        plugins: []
        cmdToken: "!"
        verbose: true
        

Bot = (config) ->
        slack = []
        plugins = []
        obj = {}
        obj.config = if config then config else _DEFAULTS
        slack = new Slack(obj.config.token, obj.config.autoReconnect, obj.config.autoMark)
        
        logMessage = (message) ->
                if obj.config.verbose
                        ts = "[" + new Date().toISOString() + "]";
                        console.log(ts + " " + message)

        getCommand = (command) ->
                command = command.substr 1
                return _.find obj.config.plugins, { "name": command }
                

        sendMessage = (channelName, msg) ->
                channel = slack.getChannelGroupOrDMByID(channelName)
                if channel then channel.send msg
                

        # Call message 
        handleMessage = (message) ->
                logMessage(message.text)
                msg = message.text.split(' ')
                if _.startsWith msg[0], obj.config.cmdToken
                        cmd = getCommand msg[0]
                        response = cmd.messageHandler(_.rest(msg)) if cmd
                        sendMessage message.channel, response


        # Open
        openAction = ->
                _.forEach(plugins, (plugin) ->
                        plugin.open() if plugin.open
                )


        errorHandler = (error) ->
                console.error(error)

        obj.startBot = ->
                
                plugins = config.plugins
        
                slack.on 'open', openAction
                slack.on 'message', handleMessage
                slack.on 'error', errorHandler
                slack.login()


        if process.env.NODE_ENV == "test"
                obj._private =
                        handleMessage: handleMessage
                        openAction: openAction
                        errorHandler: errorHandler
                        plugins: plugins
                        getCommand: getCommand
                        slack: slack
        return obj
                    

module.exports = Bot






        
