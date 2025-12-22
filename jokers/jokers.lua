-- Joker
SMODS.Joker {
    key = "joker2",
    loc_txt = {
        name = "Joker 2",
        text = {
           "This is the in-game description of this joker. {C:mult}+#1# {} Mult" -- #1# is a variable that's stored in config, and is put into loc_vars. C:mult is coloring.
        }
    },
    atlas = "Bamlatro",
    pos = { x = 0, y = 0 },
    rarity = 1,
    blueprint_compat = true,
    cost = 2,
    discovered = true,
    config = { extra = { mult = 4 }, },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}