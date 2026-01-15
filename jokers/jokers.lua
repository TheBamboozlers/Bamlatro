--[[
name:
    FeedTheBeast
notes:
    Copies of this joker doesn't eat additional played cards. Maybe fix?
]]--
--[[SMODS.Joker{
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
}]]--

--[[
name:
    2Mas
]]--
SMODS.Joker{
    key = "_2mas",
    config = {
        extra = {
            xmult0 = 2.2,
            bam_bonus = 1
        }
    },
    loc_txt = {
        ['name'] = '2Mas',
        ['text'] = {
            [1] = 'Every played {C:blue}2{}',
            [2] = 'gives {C:red}x#1# Mult{}',
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
    pos = { x = 1, y = 0 },

    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.xmult0 * card.ability.extra.bam_bonus}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:get_id() == 2 then
                return {
                    Xmult = card.ability.extra.xmult0 * bam_bonus
                }
            end
        end
    end
}

--[[
name:
    The Short Term
]]--
--[[SMODS.Joker{
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
}]]--

--[[
name:
    The Long Game
]]--
--[[SMODS.Joker{
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
}]]--

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
            card_draw = 1,
            bam_bonus = 1
        }
    },
    loc_txt = {
        ['name'] = 'Andres',
        ['text'] = {
            [1] = 'For each {C:blue}6{} or {C:blue}7{} scored,',
            [2] = 'draw #2# additional card',
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
    pos = { x = 2, y = 0 },
    
    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.bonusCardsToDraw, card.ability.extra.bam_bonus}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if (context.other_card:get_id() == 6 or context.other_card:get_id() == 7) then
                local target_card = context.other_card
                card.ability.extra.bonusCardsToDraw = (card.ability.extra.bonusCardsToDraw) + (1 * card.ability.extra.bam_bonus)
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
    CS:GO Crates
]]--
SMODS.Joker{
    key = "csgocrates",
    config = {
        extra = {
            sellValueIncrease = 1,
            odds = 10,
            bam_bonus = 1
        }
    },
    loc_txt = {
        ['name'] = 'CS:GO Crates',
        ['text'] = {
            [1] = 'After every round, {X:money,C:white}double{}',
            [2] = 'this joker\'s sell value.',
            [3] = 'After every shop, {C:green}#3# in #4#{}',
            [4] = 'chance for market crash.',
            [5] = '{C:money}Max value $#5#.{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    cost = 2,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 3, y = 0 },
    
    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j_bam_csgocrates') 
        return {vars = {card.ability.extra.sellValueIncrease, card.ability.extra.var1, new_numerator, new_denominator, 100*card.ability.extra.bam_bonus}}
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval  then
            return {
                func = function()
                    card.ability.extra.sellValueIncrease = (card.ability.extra.sellValueIncrease) * 2
                    return true
                end,
                extra = {
                    func = function()local my_pos = nil
                        for i = 1, #G.jokers.cards do
                            if G.jokers.cards[i] == card then
                                my_pos = i
                                break
                            end
                        end
                        local target_card = G.jokers.cards[my_pos]
                        if card.ability.extra.sellValueIncrease > 100*card.ability.extra.bam_bonus then
                            card.ability.extra.sellValueIncrease = 100*card.ability.extra.bam_bonus
                        end
                        target_card.ability.extra_value = (card.ability.extra.sellValueIncrease - 1)
                        target_card:set_cost()
                        return true
                    end,
                    message = (card.ability.extra.sellValueIncrease >= 63) and "Max!" or "Double!",
                    colour = (card.ability.extra.sellValueIncrease >= 63) and G.C.FILTER or G.C.MONEY
                }
            }
        end
        if context.ending_shop then
            if SMODS.pseudorandom_probability(card, 'group_0_344f8d99', 1, card.ability.extra.odds, 'j_bam_csgocrates', false) then
                return {
                    func = function()
                        card.ability.extra.sellValueIncrease = 1
                        return true
                    end,
                    extra = {
                        func = function()local my_pos = nil
                            for i = 1, #G.jokers.cards do
                                if G.jokers.cards[i] == card then
                                    my_pos = i
                                    break
                                end
                            end
                            local target_card = G.jokers.cards[my_pos]
                            target_card.ability.extra_value = (card.ability.extra.sellValueIncrease - 1)
                            target_card:set_cost()
                            return true
                        end,
                        message = "Market Crash!!",
                        colour = G.C.RED
                    }
                }
            end
        end
    end
}

--[[
name:
    patch1236
]]--
SMODS.Joker{
    key = "patch1236",
    config = {
        extra = {
            odds = 4,
            bam_bonus = 1
        }
    },
    loc_txt = {
        ['name'] = 'Patch 1.23.6',
        ['text'] = {
            [1] = 'Whenever a {C:attention}Queen{} is scored,',
            [2] = '{C:green}#1# in #2#{} chance to convert it',
            [3] = 'to a {C:attention}King{} with a {C:dark_edition}random Edition{}.',
            [4] = '{C:inactive}(Initial hand still scores){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 4, y = 0 },

    loc_vars = function(self, info_queue, card)
        
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, card.ability.extra.bam_bonus, card.ability.extra.odds, 'j_bam_redhomas') 
        return {vars = {new_numerator, new_denominator}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:get_id() == 12 then
                if SMODS.pseudorandom_probability(card, 'group_0_344f8d99', card.ability.extra.bam_bonus, card.ability.extra.odds, 'j_bam_patch1236', false) then
                    local scored_card = context.other_card
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            assert(SMODS.change_base(scored_card, scored_card.base.suit, "King"))
                            local edition = pseudorandom_element({'e_foil','e_holo','e_polychrome'}, 'random edition')
                            scored_card:set_edition(edition, true)
                            return true
                        end
                    }))
                    return {
                        extra = {
                            message = "Yaoi!",
                            colour = G.C.RED
                        }
                    }
                end
            end
        end
    end
}

--[[
name:
    redhomas
]]--
SMODS.Joker{
    key = "redhomas",
    config = {
        extra = {
            odds = 6,
            xmult0 = 1.25,
            bam_bonus = 1
        }
    },
    loc_txt = {
        ['name'] = 'redhomas',
        ['text'] = {
            [1] = '{X:red,C:white}X#3#{} Mult.',
            [2] = 'Every round,{C:green} #1# in #2# {}chance',
            [3] = 'to duplicate this joker.',
            [4] = '{C:dark_edition}Copies are negative.{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 5, y = 0 },
    
    loc_vars = function(self, info_queue, card)
        
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j_bam_redhomas') 
        return {vars = {new_numerator, new_denominator, (card.ability.extra.bam_bonus*0.25)+1}}
    end,
    
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            if SMODS.pseudorandom_probability(card, 'group_0_02d9f56b', 1, card.ability.extra.odds, 'j_bam_redhomas', false) then
                SMODS.calculate_effect({func = function()
                    local target_joker = nil
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i] == card then
                            target_joker = G.jokers.cards[i]
                            break
                        end
                    end
                    if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                        G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local copied_joker = copy_card(target_joker, nil, nil, nil, target_joker.edition and target_joker.edition.negative)
                                copied_joker:set_edition("e_negative", true)
                                copied_joker:add_to_deck()
                                G.jokers:emplace(copied_joker)
                                G.GAME.joker_buffer = 0
                                play_sound('bam_sfx_redhomas', 1, 0.4)
                                return true
                            end
                        }))
                    end
                end}, card)
                return {
                    message = ":redhomas:",
                    colour = G.C.RED,
                    --sound = 'bam_sfx_redhomas',
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main  then
            return {
                Xmult = (card.ability.extra.bam_bonus*0.25)+1
            }
        end
    end
}

--[[
name:
    Justin
]]--
SMODS.Joker{
    key = "justin",
    config = {
        extra = {
            bam_bonus = 1
        }
    },
    loc_txt = {
        ['name'] = 'Justin',
        ['text'] = {
            [1] = '{C:inactive}\"I can play anything.\"{}',
            [2] = 'Each hand, you may play up to',
            [3] = 'as many cards as {C:attention}hand size{}.',
            [4] = 'Each hand, lose {C:money}-$#1#{}.'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 6, y = 0 },

    loc_vars = function(self, info_queue, card)
        return {vars = {2-card.ability.extra.bam_bonus}}
    end,
    
    calculate = function(self, card, context)
        SMODS.change_play_limit(G.hand.config.card_limit - G.GAME.starting_params.play_limit)

        if context.cardarea == G.jokers and context.joker_main  then
            return {
                
                func = function()
                    
                    local current_dollars = G.GAME.dollars
                    local target_dollars = G.GAME.dollars - (2-bam_bonus)
                    local dollar_value = target_dollars - current_dollars
                    ease_dollars(dollar_value)
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "-"..tostring(2-bam_bonus), colour = G.C.MONEY})
                    return true
                end
            }
        end
    end,
    
    --[[add_to_deck = function(self, card, from_debuff)
        SMODS.change_play_limit(99)
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_play_limit(-99)
    end]]--
}

--[[
name:
    Miata
]]--
SMODS.Joker{
    key = "miata",
    config = {
        extra = {
            bam_bonus = 1
        }
    },
    loc_txt = {
        ['name'] = 'Miata',
        ['text'] = {
            [1] = 'If {C:attention}first hand{} of round is a',
            [2] = 'single {C:attention}2{}, gain #1# {C:tarot}Charm Tag{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 7, y = 0 },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_TAGS.tag_charm
        return {vars = {card.ability.extra.bam_bonus}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if (G.GAME.current_round.hands_played == 0 and #context.scoring_hand) == 1 and (function()
                local count = 0
                for _, playing_card in pairs(context.scoring_hand or {}) do
                    if playing_card:get_id() == 2 then
                        count = count + 1
                    end
                end
                return count == #context.scoring_hand
            end)() then
                return {
                    func = function()
                        local times = card.ability.extra.bam_bonus
                        for i = 1, times do
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    local tag = Tag("tag_charm")
                                    if tag.name == "Orbital Tag" then
                                        local _poker_hands = {}
                                        for k, v in pairs(G.GAME.hands) do
                                            if v.visible then
                                                _poker_hands[#_poker_hands + 1] = k
                                            end
                                        end
                                        tag.ability.orbital_hand = pseudorandom_element(_poker_hands, "bam_orbital")
                                    end
                                    tag:set_ability()
                                    add_tag(tag)
                                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                                    return true
                                end
                            }))
                        end
                        return true
                    end,
                    message = "Created Tag!"
                }
            end
        end
    end
}

--[[
name:
    Daniel
]]--
SMODS.Joker{
    key = "daniel",
    config = {
        extra = {
            bam_bonus = 1
        }
    },
    loc_txt = {
        ['name'] = 'Daniel',
        ['text'] = {
            [1] = 'If final score is within',
            [2] = '{C:attention}#1#%{} of blind requirement,',
            [3] = 'gain a {C:tarot}Ethereal Tag{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 0, y = 1 },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_TAGS.tag_ethereal
        return {vars = {card.ability.extra.bam_bonus*25}}
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval  then
            if (G.GAME.chips / G.GAME.blind.chips <= ((card.ability.extra.bam_bonus*0.25)+1)) then
                return {
                    func = function()
                        local times = card.ability.extra.bam_bonus
                        for i = 1, times do
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    local tag = Tag("tag_ethereal")
                                    if tag.name == "Orbital Tag" then
                                        local _poker_hands = {}
                                        for k, v in pairs(G.GAME.hands) do
                                            if v.visible then
                                                _poker_hands[#_poker_hands + 1] = k
                                            end
                                        end
                                        tag.ability.orbital_hand = pseudorandom_element(_poker_hands, "bam_orbital")
                                    end
                                    tag:set_ability()
                                    add_tag(tag)
                                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                                    return true
                                end
                            }))
                        end
                        return true
                    end,
                    message = "Created Tag!"
                }
            end
        end
    end
}

--[[
name:
    Inheritance
]]--
SMODS.Joker{
    key = "inheritance",
    config = {
        extra = {
            cardsBought = 0,
            countedSelfYet = false,
            bam_bonus = 1
        }
    },
    loc_txt = {
        ['name'] = 'Inheritance',
        ['text'] = {
            [1] = 'For every {C:attention}#2#{} cards {C:attention}bought{}',
            [2] = 'while having this joker,',
            [3] = 'gain an {C:money}Economy Tag{}',
            [4] = 'upon {C:attention}selling{} this joker.',
            [5] = '{C:inactive}(Currently #1# cards){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 1, y = 1 },
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_TAGS.tag_economy
        return {vars = {card.ability.extra.cardsBought, (5-card.ability.extra.bam_bonus)}}
    end,
    
    calculate = function(self, card, context)
        if context.buying_card and not context.buying_self then
            if (function()
                for i, v in pairs(G.jokers.cards) do
                    if v.config.center.key == "j_bam_inheritance" then 
                        return true
                    end
                end
            end)() then
                return {
                    func = function()
                        card.ability.extra.cardsBought = (card.ability.extra.cardsBought) + 1
                        return true
                    end,
                }
            end
        end
        if context.selling_self then
            return {
                func = function()
                    local times = card.ability.extra.cardsBought / (5-card.ability.extra.bam_bonus)
                    for i = 1, times do
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local tag = Tag("tag_economy")
                                if tag.name == "Orbital Tag" then
                                    local _poker_hands = {}
                                    for k, v in pairs(G.GAME.hands) do
                                        if v.visible then
                                            _poker_hands[#_poker_hands + 1] = k
                                        end
                                    end
                                    tag.ability.orbital_hand = pseudorandom_element(_poker_hands, "jokerforge_orbital")
                                end
                                tag:set_ability()
                                add_tag(tag)
                                play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                                return true
                            end
                        }))    
                    end
                    return true
                end,
                message = "Inheritance!",
                colour = G.C.MONEY,
            }
        end
    end,
}

--[[
name:
    James
]]--
SMODS.Joker{
    key = "james",
    config = {
        extra = {
            jacksScored = 0,
            jackThreshold = 9,
            bam_bonus = 1
        }
    },
    loc_txt = {
        ['name'] = 'James',
        ['text'] = {
            [1] = 'For every {C:attention}#2# Jacks{} scored',
            [2] = 'gain an {C:blue}Double Tag{}',
            [3] = '{C:inactive}(Currently #1#/#2#){}',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 2, y = 1 },
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_TAGS.tag_double
        return {vars = {card.ability.extra.jacksScored, card.ability.extra.jackThreshold-card.ability.extra.bam_bonus}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 11 then

                card.ability.extra.jacksScored = (card.ability.extra.jacksScored) + 1

                if card.ability.extra.jacksScored < (card.ability.extra.jackThreshold-card.ability.extra.bam_bonus) then
                    return {
                        extra = {
                            --card:juice_up(1, 1)
                            --message = "J Up!",
                            --message_card = card,
                            func = function() -- This is for timing purposes, everything here runs after the message
                                G.E_MANAGER:add_event(Event({
                                    func = (function()
                                        card:juice_up()
                                        return true
                                    end)
                                }))
                            end
                        },
                    }
                end

                if card.ability.extra.jacksScored >= (card.ability.extra.jackThreshold-card.ability.extra.bam_bonus) then
                    card.ability.extra.jacksScored = 0
                    return {
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    local tag = Tag("tag_double")
                                    if tag.name == "Orbital Tag" then
                                        local _poker_hands = {}
                                        for k, v in pairs(G.GAME.hands) do
                                            if v.visible then
                                                _poker_hands[#_poker_hands + 1] = k
                                            end
                                        end
                                        tag.ability.orbital_hand = pseudorandom_element(_poker_hands, "jokerforge_orbital")
                                    end
                                    tag:set_ability()
                                    add_tag(tag)
                                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                                    return true
                                end
                            }))
                        end,
                        message = "James!",
                        message_card = card,
                        colour = G.C.BLUE,
                    }
                end
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