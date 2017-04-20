if SERVER then AddCSLuaFile() end

TFAStarWars = TFAStarWars or { }

TFAStarWars.Version = 1.1
TFAStarWars.VCheckLink = "https://raw.githubusercontent.com/Servius/tfa-sw-weapons-repository/master/info.txt"

function TFAStarWars:DoNotify(...)
	local args = { ... }

	if SERVER then
		net.Start("TFAStarWars_nfy")
			net.WriteString(args[2])

			net.WriteInt(args[3] or -1, 6) 
			net.WriteInt(args[4] or -1, 16) 
		net.Send(args[1])
	else
		if args[1] == nil or not isstring(args[1]) then args[1] = "<empty>" end
		if args[2] == nil or args[2] == -1 or not isnumber(args[2]) then args[2] = NOTIFY_GENERIC end
		if args[3] == nil or args[3] == -1 or not isnumber(args[3]) then args[3] = 5 end

		notification.AddLegacy(args[1], args[2], args[3]) 
		surface.PlaySound("ambient/water/drip3.wav")
	end
end

function TFAStarWars:LoadFile(path)
	if SERVER then AddCSLuaFile(path) end
	include(path)

	print("[Data] Loaded " .. path .. " file")
end

TFAStarWars:LoadFile("tfa_starwars/net/server.lua")
TFAStarWars:LoadFile("tfa_starwars/net/client.lua")

if SERVER then
	-- Version checker
	hook.Add("Initialize", "TFAStarWars_versionautocheck", function()
		-- For some reason it won't work without timer
		timer.Simple(0, function()
			http.Fetch(TFAStarWars.VCheckLink,
				function(body, len, headers, code)
					if not body then return end
					local info = util.JSONToTable(body)

					if info then
						local version = info.AddonInfo.Version

						if version == TFAStarWars.Version then
							MsgC(Color(0, 255, 0), "All your Star Wars addons seem up to date!\n")
							TFAStarWars.IsUpToDate = true
						else
							local msg1 = "Seems like one of your TFA Star Wars packs is outdated!\n"
							local msg2 = "New version: " .. version .. "\n"
							local msg3 = "Your version: " .. TFAStarWars.Version .. "!\n"
							MsgC(Color(255, 100, 80), msg1, msg2, msg3)
						end
					else
						print("Can't read TFA Star Wars version!")
					end
				end,

				function(error)
					print("Cannot check version of your TFA Star Wars addons!")
				end
			)
		end)
	end)
end

TFAStarWars.Loaded = true
hook.Run("TFAStarWars_loaded")

if SERVER then 
	MsgC(Color(0, 200, 255), "TFA Star Wars addons have been loaded!\n") 
end