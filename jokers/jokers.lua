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
    2Mas
]]--
SMODS.Joker{
    key = "_2mas",
    config = {
        extra = {
            xmult0 = 2.2
        }
    },
    loc_txt = {
        ['name'] = '2Mas',
        ['text'] = {
            [1] = 'Every played {C:blue}2{}',
            [2] = 'gives {C:red}x2.2 Mult{}',
            [3] = 'when scored.'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 4,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 2, y = 0 },
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:get_id() == 2 then
                return {
                    Xmult = 2.2
                }
            end
        end
    end
}

--[[
name:
    The Short Term
]]--
SMODS.Joker{
    key = "theshortterm",
    loc_txt = {
        name = "The Short Term",
        text = {
            "After #2# rounds, sell to apply",
            "{C:dark_edition}negative{} to a random joker.",
            "{C:inactive}(Currently {}{C:attention}#1#{}{C:inactive}/#2#){}"
        }
    },
    config = {
        extra = {
            rounds_accumulated = 0,
            rounds_threshold = 3,
            base = 1,
        }
    },
    loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.rounds_accumulated, (card.ability.extra.rounds_threshold * card.ability.extra.base)} }
	end,
    atlas = 'Bamlatro',
    pos = { x = 3, y = 0 },
    rarity = 1,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,

    calculate = function(self, card, context)
        if context.selling_self and (card.ability.extra.rounds_accumulated >= (card.ability.extra.rounds_threshold * card.ability.extra.base)) and not context.blueprint then
            local jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card then
                    jokers[#jokers + 1] = G.jokers.cards[i]
                end
            end
            local chosen_index = math.random(1, #jokers)
            local chosen_joker = jokers[chosen_index]
            print(chosen_index)
            print(chosen_joker.name)
            chosen_joker:set_edition({ negative = true })
            return { 
                message = "Negative!",
                colour = G.C.Negative
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.rounds_accumulated = card.ability.extra.rounds_accumulated + 1
            if card.ability.extra.rounds_accumulated >= (card.ability.extra.rounds_threshold * card.ability.extra.base) then
                local eval = function(card) return not card.REMOVED end
                juice_card_until(card, eval, true)
            end
            return {
                message = (card.ability.extra.rounds_accumulated < (card.ability.extra.rounds_threshold * card.ability.extra.base)) and
                    (card.ability.extra.rounds_accumulated .. '/' .. (card.ability.extra.rounds_threshold * card.ability.extra.base)) or
                    localize('k_active_ex'),
                colour = G.C.FILTER
            }
        end
    end,
}

--[[
name:
    The Long Game
]]--
SMODS.Joker{
    key = "thelonggame",
    loc_txt = {
        name = "The Long Game",
        text = {
            "After #2# rounds, sell to duplicate",
            "2 random jokers with {C:dark_edition}negative{}.",
            "{C:inactive}(Currently {}{C:attention}#1#{}{C:inactive}/#2#){}"
        }
    },
    config = {
        extra = {
            rounds_accumulated = 0,
            rounds_threshold = 3,
            base = 1,
        }
    },
    loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.rounds_accumulated, (card.ability.extra.rounds_threshold * card.ability.extra.base)} }
	end,
    atlas = 'Bamlatro',
    pos = { x = 3, y = 0 },
    rarity = 1,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,

    calculate = function(self, card, context)
        if context.selling_self and (card.ability.extra.rounds_accumulated >= (card.ability.extra.rounds_threshold * card.ability.extra.base)) and not context.blueprint then
            local jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card then
                    jokers[#jokers + 1] = G.jokers.cards[i]
                end
            end
            local chosen_index = math.random(1, #jokers)
            local chosen_joker = jokers[chosen_index]
            print(chosen_index)
            print(chosen_joker.name)
            chosen_joker:set_edition({ negative = true })
            return { 
                message = "Negative!",
                colour = G.C.Negative
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.rounds_accumulated = card.ability.extra.rounds_accumulated + 1
            if card.ability.extra.rounds_accumulated >= (card.ability.extra.rounds_threshold * card.ability.extra.base) then
                local eval = function(card) return not card.REMOVED end
                juice_card_until(card, eval, true)
            end
            return {
                message = (card.ability.extra.rounds_accumulated < (card.ability.extra.rounds_threshold * card.ability.extra.base)) and
                    (card.ability.extra.rounds_accumulated .. '/' .. (card.ability.extra.rounds_threshold * card.ability.extra.base)) or
                    localize('k_active_ex'),
                colour = G.C.FILTER
            }
        end
    end,
}

--[[
name:
    Andres
]]--
SMODS.Joker{
    key = "andres",
    config = {
        extra = {
            bonusCardsToDraw = 0,
            card_draw0 = 1,
            card_draw = 1
        }
    },
    loc_txt = {
        ['name'] = 'Andres',
        ['text'] = {
            [1] = 'For each {C:blue}6{} or {C:blue}7{} scored,',
            [2] = 'draw an additional card',
            [3] = 'the next time you draw.',
            [4] = '{C:inactive}(Currently #1# cards){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 4, y = 0 },
    
    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.bonusCardsToDraw}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if (context.other_card:get_id() == 6 or context.other_card:get_id() == 7) then
                local target_card = context.other_card
                card.ability.extra.bonusCardsToDraw = (card.ability.extra.bonusCardsToDraw) + 1
                return true
            end
        end
        if context.hand_drawn or context.other_drawn then
            if (card.ability.extra.bonusCardsToDraw or 0) > 0 then
                local bonusCardsToDraw_value = card.ability.extra.bonusCardsToDraw
                if G.hand and #G.hand.cards > 0 then
                    SMODS.draw_cards(bonusCardsToDraw_value)
                end
                return {
                    message = "+"..tostring(bonusCardsToDraw_value).." Cards Drawn",
                    extra = {
                        func = function()
                            card.ability.extra.bonusCardsToDraw = 0
                            return true
                        end,
                        colour = G.C.BLUE
                    }
                }
            end
        end
    end
}


--[[
name:
    New Joker
notes:
    if you wish
]]--