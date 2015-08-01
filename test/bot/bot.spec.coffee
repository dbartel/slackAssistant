assert     = require("chai").assert
sinon      = require "sinon"
_          = require "lodash"
shim       = require "../shim"

Bot        = shim.Bot
slack      = new shim.stubs.slack

describe "bot", ->
  bot = null
  plugin = null
  beforeEach ->
    plugin =
      name: "testPlugin"
      messageHandler: sinon.stub().returns("response")
    
    config =
      verbose: false
      token: "token"
      autoReconnect: false
      autoMark: false
      cmdToken: "!"
      plugins: [plugin]
    
    bot = new Bot(config)
    
  describe "errorHandler", ->
    beforeEach ->
      console.error = sinon.spy()
    it "should log an error", ->
      bot._private.errorHandler("error")
      assert.isTrue console.error.called, "error called"
  describe "handleMessage", ->
    describe "with a normal message", ->
      it "should take no action", ->
        bot._private.handleMessage {text: "normal chat messsage"}
        assert.isFalse plugin.messageHandler.called, "no action taken"
    describe "with a command", ->
      describe "where the plugin exists", ->
        it "should execute the proper message handler", ->
          bot._private.handleMessage {text: "!testPlugin message" }
          assert.isTrue plugin.messageHandler.called, "message handler called"
      describe "where the plugin does not exist", ->
        it "should not call a plugin", ->
          bot._private.handleMessage {text: "!badPlugin message" }
          assert.isFalse plugin.messageHandler.called, "no handler called"
                        
  describe "openAction", ->
    it "should call the plugin open handlers", ->
      bot._private.openAction
      _.forEach bot._private.plugins, (plugin) ->
        assert.isTrue plugin.open.called "open handler called"
              
              
