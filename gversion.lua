local gVersion = {}
gVersion.FilePath = "data/gversion_version.txt"
gVersion.Cloud = "https://raw.githubusercontent.com/Starfox64/gVersion/master/data/gversion_version.txt"
gVersion.AddonName = "gVersion"
gVersion.NotifyClient = true

function gVersion.CheckForUpdates()
	http.Fetch(gVersion.Cloud,
		function( data )
			gVersion.Local = tonumber(file.Read(gVersion.FilePath, "GAME")) or 0
			gVersion.Remote = tonumber(data) or 0
			if gVersion.Remote <= gVersion.Local then
				gVersion.Status = 3
				Msg("[gVersion] ")
				MsgC(Color(0, 240, 0), gVersion.AddonName.." is up to date! (Revision: "..gVersion.Remote..")\n")
			else
				gVersion.Status = 2
				Msg("[gVersion] ")
				MsgC(Color(240, 240, 0), gVersion.AddonName.." is not up to date! (Local: "..gVersion.Local..", Remote: "..gVersion.Remote..")\n")
			end
		end,
		function( err )
			gVersion.Status = 1
			Msg("[gVersion] ")
			MsgC(Color(240, 0, 0), gVersion.AddonName.." could not check for updates!\n")
			MsgN(err)
		end
	)
end
gVersion.CheckForUpdates()

if gVersion.NotifyClient then
	hook.Add("PlayerInitialSpawn", "gVersion"..gVersion.AddonName, function( ply )
		if not gVersion.Status then
			ply:SendLua('Msg("[gVersion] ")	MsgC(Color(240, 0, 0), '..gVersion.AddonName..'.." unknown error!\n")')
		elseif gVersion.Status == 1 then
			ply:SendLua('Msg("[gVersion] ")	MsgC(Color(240, 0, 0), '..gVersion.AddonName..'.." could not check for updates!\n")')
		elseif gVersion.Status == 2 then
			ply:SendLua('Msg("[gVersion] ")	MsgC(Color(240, 240, 0), '..gVersion.AddonName..'.." is not up to date!\n")')
		elseif gVersion.Status == 3 then
			ply:SendLua('Msg("[gVersion] ")	MsgC(Color(0, 240, 0), '..gVersion.AddonName..'.." is up to date!\n")')
		end
	end)
end