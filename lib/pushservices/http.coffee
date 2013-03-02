url = require 'url'
request = require 'request'

class PushServiceHTTP
    validateToken: (token) ->
        info = url.parse(token)
        if info?.protocol in ['http:', 'https:']
            return token

    constructor: (@conf, @logger, tokenResolver) ->

    push: (subscriber, subOptions, payload) ->
        subscriber.get (info) =>
            options = url.parse(info.token)

            body =
                event: payload.event.name
                title: payload.title
                message: payload.msg.default
                data: JSON.stringify(payload.data)

            request
              method: 'POST'
              uri: url.format(options)
              form: body
            ,
              (error, response, body) ->
                console.log(body)

            # req = http.request(options)

            # req.on 'error', (e) =>
                # TODO: allow some error before removing
                #@logger?.warn("HTTP Automatic unregistration for subscriber #{subscriber.id}")
                #subscriber.delete()

            # req.write(JSON.stringify(body))

exports.PushServiceHTTP = PushServiceHTTP
