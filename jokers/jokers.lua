--[[
name:
    FeedTheBeast
notes:
    Copies of this joker doesn't eat additional played cards. Maybe fix?
]]--
SMODS.Joker{
    key = "feedthebeast",
    loc_txt = {
        name = "Feed The Beast",
        text = {
            "{C:attention}Every hand{}, the rightmost",
            "played card is {C:attention}destroyed{}, and",
            "this joker gains {X:mult,C:white} X#1# {} Mult.",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"
        }
    },
    config = {
        extra = {
            Xmult = 1,
            increment = 0.1,
            base = 1
        }
    },
    loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.increment, card.ability.extra.Xmult} }
	end,
    atlas = 'Bamlatro',
    pos = { x = 1, y = 0 },
    rarity = 3,
    cost = 9,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,

    calculate = function(self, card, context)

		if context.joker_main then
            return {
                Xmult_mod = card.ability.extra.Xmult,
                message = localize { type = "variable", key = "a_xmult", vars = { card.ability.extra.Xmult }}
            }
		end

        if context.after then
            local c = context.full_hand[#context.full_hand]
            G.E_MANAGER:add_event(Event({
                blocking = true,
                --delay = 4,
                --after = true,
                func = function()
                    c:juice_up(0.8, 0.8)
                    c:start_dissolve({ HEX("049100") }, nil, 1)
                    return true
                end
            }))
            c.destroyed = true
            card.ability.extra.Xmult = card.ability.extra.Xmult + (card.ability.extra.increment * card.ability.extra.base)
            return {
				message = 'Eaten!',
				colour = G.C.GREEN,
				card = card
			}
        end
	end
}


--[[
name:
    New Joker
notes:
    if you wish
]]--