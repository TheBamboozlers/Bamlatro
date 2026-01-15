--Creates an atlas for cards to use
SMODS.Atlas {
	-- Key for code to find it with
	key = "Bamlatro",
	-- The name of the file, for the code to pull the atlas from
	path = "Bamlatro.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

SMODS.Sound {
    key = "sfx_redhomas",
	path = "redhomas.ogg",
}

-- Load all lua files
assert(SMODS.load_file("decks/cheats.lua"))() -- remove for release
assert(SMODS.load_file("jokers/jokers.lua"))()

assert(SMODS.load_file("editions/editions.lua"))()
assert(SMODS.load_file("tarots/tarots.lua"))()