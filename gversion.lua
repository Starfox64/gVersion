local gVersion = {}
gVersion.FilePath = "data/gversion_version.txt" -- Where is the local version file stored.
gVersion.Cloud = "https://raw.githubusercontent.com/Starfox64/gVersion/master/data/gversion_version.txt" -- The URL of the remove version file if you are using a file from github you can get this link by hitting 'RAW' on it.
gVersion.AddonName = "gVersion" -- The name of your addon.
gVersion.NotifyClient = true -- Should gVersion echo whether or not the addon is up to date to clients?

if SERVER then
	function gVersion.CheckForUpdates()
		http.Fetch(gVersion.Cloud,
			function( data )
				if file.Exists(gVersion.FilePath, "GAME") then
					gVersion.Local = tonumber(file.Read(gVersion.FilePath, "GAME")) or 0
				else
					gVersion.Local = 0
					MsgC(Color(255, 100, 100), "[gVersion] ")
					MsgC(Color(255, 100, 100), gVersion.AddonName.." could not find it's local version!\n")
				end
				gVersion.Remote = tonumber(data) or 0
				if gVersion.Remote <= gVersion.Local then
					gVersion.Status = 3
					MsgC(Color(255, 100, 100), "[gVersion] ")
					MsgC(Color(100, 255, 100), gVersion.AddonName.." is up to date! (Revision: "..gVersion.Remote..")\n")
				else
					gVersion.Status = 2
					MsgC(Color(255, 100, 100), "[gVersion] ")
					MsgC(Color(255, 255, 100), gVersion.AddonName.." is not up to date! (Local: "..gVersion.Local..", Remote: "..gVersion.Remote..")\n")
				end
			end,
			function( err )
				gVersion.Status = 1
				MsgC(Color(255, 100, 100), "[gVersion] ")
				MsgC(Color(255, 100, 100), gVersion.AddonName.." could not check for updates!\n")
				MsgN(err)
			end
		)
	end
	gVersion.CheckForUpdates()

	if gVersion.NotifyClient then
		util.AddNetworkString("gVersionNotify")
		hook.Add("PlayerInitialSpawn", "gVersion"..gVersion.AddonName, function( ply )
			net.Start("gVersionNotify")
			net.WriteInt(gVersion.Status or 0, 4)
			net.Send(ply)
		end)
	end
else
	net.Receive("gVersionNotify", function()
		local status = net.ReadInt(4)
		MsgC(Color(255, 100, 100), "[gVersion] ")
		if status == 0 then
			MsgC(Color(255, 100, 100), gVersion.AddonName.." unknown error!\n")
		elseif status == 1 then
			MsgC(Color(255, 100, 100), gVersion.AddonName.." could not check for updates!\n")
		elseif status == 2 then
			MsgC(Color(255, 255, 100), gVersion.AddonName.." is not up to date!\n")
		elseif status == 3 then
			MsgC(Color(100, 255, 100), gVersion.AddonName.." is up to date!\n")
		end
	end)
end