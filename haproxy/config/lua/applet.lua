core.register_service("sample_applet", "http", function(applet)
    applet:start_response()
    applet:send(string.format("sent from Lua %s\n", _VERSION))
end)
