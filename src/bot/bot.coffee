Slack = require 'slack-client'
_ = require 'lodash'

Bot = (config) ->
        slack = []
        plugins = []
        obj = {}
        obj.config = config if config

        logMessage = (message) ->
                if obj.config.verbose
                        ts = "[" + new Date().toISOString() + "]";
                        console.log("[LOG]" + message)

        # Call message 
        messageAction = (message) ->
                logMessage(message.text) 
                _.forEach plugins, (plugin) ->
                        plugin.message(message) if plugin.message
        

        # Open
        openAction = ->
                _.forEach(plugins, (plugin) ->
                        plugin.open() if plugin.open
                )


        errorHandler = (error) ->
                console.error(error)

        obj.startBot = ->
                slack = new Slack(obj.config.token, obj.config.autoReconnect, obj.config.autoMark)
                plugins = config.plugins
        
                slack.on 'open', openAction
                slack.on 'message', messageAction
                slack.on 'error', errorHandler
                slack.login()


        if process.env.NODE_ENV == "test"
                obj._private =
                        messageAction: messageAction
                        openAction: openAction
                        errorHandler: errorHandler
                        plugins: plugins
        return obj
                    

module.exports = Bot






        
