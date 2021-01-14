json = dofile("lib/json.lua")
dofile("lib/curl.lua")
dofile("lib/escape-fix.lua")
dofile("lib/Fedi.lua")

targetBoard = "wg"

-- getRandomThread: Returns a random thread number from the catalog
function getRandomThread()
	local curlData = json.decode(curl("GET", "", "", "https://a.4cdn.org/" .. targetBoard .. "/catalog.json"))
	return tonumber(curlData[math.random(1, 10)]["threads"][math.random(1, 15)]["no"])
end

-- getRandomReplyImage: Provided an OP, it'll get the attachment number of a random reply in a thread
function getRandomReplyImage(threadNumber)
	local curlData = json.decode(curl("GET", "", "", "https://a.4cdn.org/" .. targetBoard .. "/thread/" .. threadNumber .. ".json"))
	print(curlData["posts"])

	local postNumber = math.random(1, #curlData["posts"])
	return {tonumber(curlData["posts"][postNumber]["tim"]), curlData["posts"][postNumber]["ext"]}
end

-- downloadImage: Provided a valid image number and extension, the file will be downloaded to the disk
function downloadImage(imgNumber, extension)
	local wallpaperImg = io.open(imgNumber .. extension, "w")
	wallpaperImg:write(curl("GET", "", "", "https://i.4cdn.org/" .. targetBoard .. "/" .. imgNumber .. extension))
	wallpaperImg:close()
end

-- postWallpaper: Posts a random wallpaper from /wg/ or /w/ to the configured account
function postWallpaper()
	-- Roll for a wallpaper from either /wg/ or /w/
	if (math.random(1, 2) == 1) then
		targetBoard = "wg"
	else
		targetBoard = "w"
	end

	local wallpaperData = getRandomReplyImage(getRandomThread()) -- Getting a random post from /wg/

	-- Making sure a valid image was chosen
	while (wallpaperData[1] == nil) do
		wallpaperData = getRandomReplyImage(getRandomThread()) -- Trying an entirely new thread, since some threads may be text-only
	end

	downloadImage(wallpaperData[1], wallpaperData[2]) -- Downloading the post's attachment
	--Fedi.postStatus("#nsfw", {wallpaperData[1] .. wallpaperData[2]}) -- Posting it
	os.remove(wallpaperData[1] .. wallpaperData[2]) -- Deleting it after
end

math.randomseed(os.time()) -- Seeding random
-- Main loop
while (true) do
	postWallpaper() -- Post the wallpaper
	os.execute("sleep " .. 3600) -- Sleep for an hour
end

