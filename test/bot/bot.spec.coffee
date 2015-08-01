assert     = require("chai").assert
sinon      = require "sinon"
_          = require "lodash"
Bot        = require("../shim").Bot



describe "bot", ->
        bot = null
        beforeEach ->
                config =
                        verbose: false
                        token: "token"
                        autoReconnect: false
                        autoMark: false
                        
                bot = new Bot(config)
        describe "errorHandler", ->
                before ->
                        console.error = sinon.spy()
                it "should log an error", ->
                        bot._private.errorHandler("error")
                        assert.isTrue console.error.called, "error called"
                        
        describe "messageAction", ->
                it "should call plugin message handlers", ->
                        bot._private.messageAction "message"
                        _.forEach bot._private.plugins, (plugin) ->
                                assert.isTrue plugin.message.called "message handler called"
                                
        describe "openAction", ->
                it "should call the plugin open handlers", ->
                        bot._private.openAction
                        _.forEach bot._private.plugins, (plugin) ->
                                assert.isTrue plugin.open.called "open handler called"                        

                        
                        
