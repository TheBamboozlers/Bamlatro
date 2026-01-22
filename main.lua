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
SMODS.Atlas {
	key = "BamlatroBlinds",
	path = "BamlatroBlinds.png",
	atlas_table = "ANIMATION_ATLAS",
	frames = 21,
	px = 34,
	py = 34,
}

SMODS.Sound {
    key = "sfx_redhomas",
	path = "redhomas.ogg",
}
SMODS.Sound {
    key = "sfx_tick",
	path = "button.ogg",
}
SMODS.Sound {
    key = "sfx_gong",
	path = "gong.ogg",
}
SMODS.Sound {
    key = "sfx_highlight",
	path = "highlight2.ogg",
}

-- Load all lua files
assert(SMODS.load_file("decks/cheats.lua"))() -- remove for release

assert(SMODS.load_file("decks/vanilla_edits.lua"))()
assert(SMODS.load_file("jokers/jokers.lua"))()
assert(SMODS.load_file("editions/editions.lua"))()
assert(SMODS.load_file("tarots/tarots.lua"))()
assert(SMODS.load_file("blinds/blinds.lua"))()