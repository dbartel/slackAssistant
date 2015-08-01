
sinon = require "sinon"
proxyquire = require "proxyquire"

# proxyquire stubs
slackClientStub = (config) ->
        slack =
                on: sinon.stub()
                login: sinon.stub()
                send: sinon.stub()
                getChannelGroupOrDMByID: sinon.stub()
        return slack
                

# Test shims
Bot = proxyquire "../src/bot/bot", {"slack-client": slackClientStub}

module.exports =
        Bot: Bot
        stubs:
                slack: slackClientStub
