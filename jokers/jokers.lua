SMODS.ObjectType {
    key = "bam_jokers",
    cards = {
        ["j_bam_2mas"] = true,
        ["j_bam_andres"] = true,
        ["j_bam_csgocrates"] = true,
        ["j_bam_patch1236"] = true,
        ["j_bam_redhomas"] = true,
        ["j_bam_justin"] = true,
        ["j_bam_miata"] = true,
        ["j_bam_daniel"] = true,
        ["j_bam_inheritance"] = true,
        ["j_bam_james"] = true,
        ["j_bam_placeholder_004"] = true,
    }
}

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
    key = "2mas",
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
    pools = { ["bam_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.xmult0 * card.ability.extra.bam_bonus}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:get_id() == 2 then
                return {
                    Xmult = card.ability.extra.xmult0 * card.ability.extra.bam_bonus
                }
            end
        end
    end
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
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 2, y = 0 },
    pools = { ["bam_jokers"] = true },
    
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
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 3, y = 0 },
    pools = { ["bam_jokers"] = true },
    
    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j_bam_csgocrates') 
        return {vars = {card.ability.extra.sellValueIncrease, card.ability.extra.var1, new_numerator, new_denominator, 50*card.ability.extra.bam_bonus}}
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
                        if card.ability.extra.sellValueIncrease > 50*card.ability.extra.bam_bonus then
                            card.ability.extra.sellValueIncrease = 50*card.ability.extra.bam_bonus
                        end
                        target_card.ability.extra_value = (card.ability.extra.sellValueIncrease - 1)
                        target_card:set_cost()
                        return true
                    end,
                    message = (card.ability.extra.sellValueIncrease >= 30*card.ability.extra.bam_bonus) and "Max!" or "Double!",
                    colour = (card.ability.extra.sellValueIncrease >= 30*card.ability.extra.bam_bonus) and G.C.FILTER or G.C.MONEY
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
            [4] = '{C:inactive}(Initial hand type still scores){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    cost = 4,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 4, y = 0 },
    pools = { ["bam_jokers"] = true },

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
                            --scored_card:set_edition(edition, true)
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
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 5, y = 0 },
    pools = { ["bam_jokers"] = true },
    
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
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 6, y = 0 },
    pools = { ["bam_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        return {vars = {2-card.ability.extra.bam_bonus}}
    end,
    
    calculate = function(self, card, context)
        SMODS.change_play_limit(G.hand.config.card_limit - G.GAME.starting_params.play_limit)

        if context.cardarea == G.jokers and context.joker_main  then
            return {
                
                func = function()
                    
                    local current_dollars = G.GAME.dollars
                    local target_dollars = G.GAME.dollars - (2-self.config.extra.bam_bonus) --TODO BUG TEST THIS!!
                    local dollar_value = target_dollars - current_dollars
                    ease_dollars(dollar_value)
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "-"..tostring(2-self.config.extra.bam_bonus), colour = G.C.MONEY})
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
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 7, y = 0 },
    pools = { ["bam_jokers"] = true },

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
            [3] = 'gain a {C:spectral}Ethereal Tag{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    cost = 4,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 0, y = 1 },
    pools = { ["bam_jokers"] = true },

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
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 1, y = 1 },
    pools = { ["bam_jokers"] = true },
    
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
            jackThreshold = 5,
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
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 2, y = 1 },
    pools = { ["bam_jokers"] = true },
    
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
    Placeholder 004
]]--
SMODS.Joker{
    key = "placeholder_004",
    config = {
        extra = {
            bam_bonus = 1
        }
    },
    loc_txt = {
        ['name'] = 'Placeholder 004',
        ['text'] = {
            [1] = '{C:enhanced}+#2# Joker Slots.{}',
            [2] = '{X:red,C:white}X#1#{} Mult.',
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
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 3, y = 1 },
    pools = { ["bam_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        return {vars = {(0.5 * card.ability.extra.bam_bonus), (card.ability.extra.bam_bonus + 1)}}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                Xmult = 0.5 * card.ability.extra.bam_bonus
            }
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + (card.ability.extra.bam_bonus + 1)
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - (card.ability.extra.bam_bonus + 1)
    end
}

--[[
name:
    Placeholder 010
]]--
SMODS.Joker{
    key = "placeholder_010",
    config = {
        extra = {
            bam_bonus = 1
        }
    },
    loc_txt = {
        ['name'] = 'Placeholder 010',
        ['text'] = {
            [1] = 'Whenever a {C:planet}Planet card{} is used,',
            [2] = '{C:attention}destroy{} up to {C:attention}#1# selected{}',
            [3] = 'playing card in hand'
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
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 4, y = 1 },
    pools = { ["bam_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.bam_bonus}}
    end,
    
    calculate = function(self, card, context)
        if context.using_consumeable then
            if context.consumeable and context.consumeable.ability.set == 'Planet' then
                for i = 0, self.config.extra.bam_bonus do
                    if #G.hand.highlighted >= 1 then
                        local card_to_destroy = pseudorandom_element(G.hand.highlighted, pseudoseed('destroy_card'))
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card_to_destroy:start_dissolve()
                                return true
                            end
                        }))
                    end
                end
            end
        end
    end,
}

--[[
name:
    Placeholder 011
]]--
SMODS.Joker{
    key = "placeholder_011",
    config = {
        extra = {
            bam_bonus = 1
        }
    },
    loc_txt = {
        ['name'] = 'Placeholder 011',
        ['text'] = {
            [1] = 'Whenever you play a',
            [2] = '{C:attention}\'X of a kind\'{} hand type,',
            [3] = 'gain #1# {C:tarot}The Emperor{}'
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
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 5, y = 1 },
    pools = { ["bam_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_emperor
        return {vars = {card.ability.extra.bam_bonus}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if next(context.poker_hands["Three of a Kind"] or context.poker_hands["Four of a Kind"] or context.poker_hands["Five of a Kind"] or context.poker_hands["Flush Five"]) then
                for i = 1, math.min(self.config.extra.bam_bonus, G.consumeables.config.card_limit - #G.consumeables.cards) do
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.4,
                        func = function()
                            play_sound('timpani')
                            SMODS.add_card({ set = 'Tarot', key = 'c_emperor'})                            
                            card:juice_up(0.3, 0.5)
                            return true
                        end
                    }))
                end
                delay(0.6)
                return {
                    message = created_consumable and localize('k_plus_tarot') or nil
                }
            end
        end
    end
}

--[[
name:
    Tinkers Construct
]]--
SMODS.Joker{
    key = "tinkersconstruct",
    config = {
        extra = {
            bam_bonus = 1,
            emult0 = 1.25,
            dollars0 = 1
        }
    },
    loc_txt = {
        ['name'] = 'Tinkers\' Construct',
        ['text'] = {
            [1] = '{C:money}Gold cards{} held in hand',
            [2] = 'also give {X:mult,C:white}X#1#{} Mult, and',
            [3] = '{C:inactive}Steel cards{} held in hand',
            [4] = 'at end of round also give {C:money}$#2#{}'
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
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 6, y = 1 },
    pools = { ["bam_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        return {vars = {(1+(0.25*card.ability.extra.bam_bonus)), (card.ability.extra.bam_bonus*2)-1}}
    end,
    
   calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round  then
            if SMODS.get_enhancements(context.other_card)["m_gold"] == true then
                return {
                    xmult = (1+(0.25*card.ability.extra.bam_bonus))
                }
            end
        end
        if context.individual and context.cardarea == G.hand and context.end_of_round  then
            if SMODS.get_enhancements(context.other_card)["m_steel"] == true then
                return {
                    dollars = ((card.ability.extra.bam_bonus*2)-1)
                }
            end
        end
    end
}


--[[
name: OP Down Mid
]]--
SMODS.Joker{
    key = "opdownmid",
    config = {
        extra = {
            bam_bonus = 1,
            hands_removed = 0,
        }
    },
    loc_txt = {
        ['name'] = 'OP Down Mid!',
        ['text'] = {
            [1] = 'For every {C:blue}hand{} above 1,',
            [2] = 'increase {C:attention}hand size{} by that amount.',
            [3] = 'Play at most #1# hand per round.',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    cost = 4,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 7, y = 1 },
    pools = { ["bam_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.bam_bonus}}
    end,
    
    calculate = function(self, card, context)
        if G.GAME.round_resets.hands ~= card.ability.extra.bam_bonus then
            local diff = G.GAME.round_resets.hands - card.ability.extra.bam_bonus
            G.hand:change_size(diff)
            card.ability.extra.hands_removed = card.ability.extra.hands_removed + diff
            G.GAME.round_resets.hands = card.ability.extra.bam_bonus
        end
    end,
    
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.hands_removed = G.GAME.round_resets.hands - 1
        G.GAME.round_resets.hands = card.ability.extra.bam_bonus
        G.hand:change_size(card.ability.extra.hands_removed)
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = 1 + card.ability.extra.hands_removed
        G.hand:change_size(-1*card.ability.extra.hands_removed) 
        G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + card.ability.extra.hands_removed
        card.ability.extra.hands_removed = 0
    end
}

--[[
name: Prop Hunt
]]--
SMODS.Joker{
    key = "prophunt",
    config = {
        extra = {
            bam_bonus = 1,
            odds = 3,
        }
    },
    loc_txt = {
        ['name'] = 'Prop Hunt',
        ['text'] = {
            [1] = 'Whenever a {C:attention}numbered card{} is scored, {C:green}#1# in #2#{} chance',
            [2] = 'to convert it to #3# random {C:attention}face card{}.',
            [3] = 'Whenever a {C:attention}face card{} is scored, {C:green}#1# in #2#{} chance',
            [4] = 'to convert it to #3# random {C:attention}numbered card{}.',
            [5] = '{C:inactive}(Initial hand type still scores){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    cost = 4,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 0, y = 2 },
    pools = { ["bam_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j_bam_prophunt') 
        return {vars = {new_numerator, new_denominator, card.ability.extra.bam_bonus}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:is_face() then
                if SMODS.pseudorandom_probability(card, 'group_0_d421f98e', 1, card.ability.extra.odds, 'j_modprefix_test', false) then
                    local scored_card = context.other_card
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local rank = pseudorandom_element({"2","3","4","5","6","7","8","9","10"}, 'edit_card_rank')
                            assert(SMODS.change_base(scored_card, scored_card.base.suit, rank))

                            if self.config.extra.bam_bonus >= 2 then
                                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                                local copied_card = copy_card(scored_card, nil, nil, G.playing_card)
                                assert(SMODS.change_base(copied_card, copied_card.base.suit, rank))
                                copied_card:add_to_deck()
                                G.deck.config.card_limit = G.deck.config.card_limit + 1
                                table.insert(G.playing_cards, copied_card)
                                G.hand:emplace(copied_card)
                                playing_card_joker_effects({true})
                                G.E_MANAGER:add_event(Event({
                                    func = function() 
                                        copied_card:start_materialize()
                                        return true
                                    end
                                }))
                            end
                            return true
                        end
                    }))
                    return {
                        extra = {
                            message = "Prop Hunt!",
                            colour = G.C.ORANGE
                        }
                    }
                end
            elseif context.other_card.base.value ~= "Ace" then
                if SMODS.pseudorandom_probability(card, 'group_0_3d68cd6e', 1, card.ability.extra.odds, 'j_bam_prophunt', false) then
                    local scored_card = context.other_card
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local rank = pseudorandom_element({"Jack","Queen","King"}, 'edit_card_rank')
                            assert(SMODS.change_base(scored_card, scored_card.base.suit, rank))

                            if self.config.extra.bam_bonus >= 2 then
                                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                                local copied_card = copy_card(scored_card, nil, nil, G.playing_card)
                                assert(SMODS.change_base(copied_card, copied_card.base.suit, rank))
                                copied_card:add_to_deck()
                                G.deck.config.card_limit = G.deck.config.card_limit + 1
                                table.insert(G.playing_cards, copied_card)
                                G.hand:emplace(copied_card)
                                playing_card_joker_effects({true})
                                G.E_MANAGER:add_event(Event({
                                    func = function() 
                                        copied_card:start_materialize()
                                        return true
                                    end
                                }))
                            end
                            return true
                        end
                    }))
                    return {
                        extra = {
                            message = "Prop Hunt!",
                            colour = G.C.ORANGE
                        }
                    }
                end
            end
        end
    end
}


--[[
name: Crash Out
]]--
SMODS.Joker{
    key = "crashout",
    config = {
        extra = {
            bam_bonus = 1,
        }
    },
    loc_txt = {
        ['name'] = 'Crash Out',
        ['text'] = {
            [1] = 'Copies abilities of',
            [2] = '{C:attention}all other jokers{}.',
            [3] = 'All playing cards {C:attention}debuffed{}',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    cost = 4,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 1, y = 2 },
    pools = { ["bam_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.jokers then
            local compatible_count = 0
            for i, joker_card in ipairs (G.jokers.cards) do
                if joker_card ~= card and joker_card.config.center.blueprint_compat then
                    compatible_count = compatible_count + 1
                end
            end
            local compat_bg_colour
            local compat_text
            if compatible_count > 0 then
                compat_bg_colour = mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
                compat_text = tostring(compatible_count)..' compatible'
            elseif true then
                compat_bg_colour = mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8)
                compat_text = 'all incompatible'
            end
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compat_bg_colour, r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. compat_text .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
            return { main_end = main_end }
        end
    end,
    
    calculate = function(self, card, context)

        if context.debuff_card then
            return {debuff = context.debuff_card.playing_card}


        --[[if context.before then
            for i, hand_card in ipairs(context.full_hand) do
                local scored_card = hand_card
                SMODS.debuff_card(scored_card, true, "crashout")
            end
            return true

        elseif context.after then
            for i, hand_card in ipairs(context.full_hand) do
                local scored_card = hand_card
                SMODS.debuff_card(scored_card, false, "crashout")
            end
            return true
        ]]--
        elseif context.joker_main then
            local other_joker = nil
            local effects = {}
            for i, joker_card in ipairs (G.jokers.cards) do
                if joker_card ~= card then
                    print("----------------------------------------------------")
                    other_joker = G.jokers.cards[i]
                    effect = SMODS.blueprint_effect(card, other_joker, context)
                    effects[#effects+1] = effect
                end
            end
            if next(effects) then return SMODS.merge_effects(effects) end
        end
    end,
}

--[[
name: Rockslide
]]--
SMODS.Joker{
    key = "rockslide",
    config = {
        extra = {
            bam_bonus = 1,
        }
    },
    loc_txt = {
        ['name'] = 'Rockslide',
        ['text'] = {
            [1] = 'Each {V:1}Stone card{} played',
            [2] = 'gives {C:red}+#1#{} Mult per',
            [3] = '{V:1}Stone card{} in played hand',
            [4] = '{C:inactive}(1=+#1# each, 2=+#2# each, etc.){}',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    cost = 4,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 2, y = 2 },
    pools = { ["bam_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.bam_bonus+2,(card.ability.extra.bam_bonus+2)*2,colours = { HEX('99a2b3') }}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if SMODS.get_enhancements(context.other_card)["m_stone"] == true then
                local mult_bonus = 0
                for _, playing_card in pairs(context.scoring_hand or {}) do
                    if SMODS.get_enhancements(playing_card)["m_stone"] == true then
                        mult_bonus = mult_bonus + (card.ability.extra.bam_bonus+2)
                    end
                end
                if mult_bonus > 0 then
                    return {
                        mult = mult_bonus
                    }
                end
                return true
            end
        end
    end
}

--[[
name: Placeholder 012
]]--
SMODS.Joker{
    key = "placeholder_012",
    config = {
        extra = {
            bam_bonus = 1,
            cards_to_generate = 0,
        }
    },
    loc_txt = {
        ['name'] = 'Placeholder 012',
        ['text'] = {
            [1] = 'After {V:1}Stone card{} is scored,',
            [2] = '{C:attention}destroy it{} and {C:attention}add #1#{}',
            [3] = 'random cards to deck',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        },
    },
    cost = 4,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 3, y = 2 },
    pools = { ["bam_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.bam_bonus+1,colours = { HEX('99a2b3') }}}
    end,
    
    calculate = function(self, card, context)
        if context.destroy_card and context.destroy_card.should_destroy  then
            return { remove = true }
        end
        if context.individual and context.cardarea == G.play  then
            context.other_card.should_destroy = false
            if SMODS.get_enhancements(context.other_card)["m_stone"] == true then
                context.other_card.should_destroy = true
                card.ability.extra.cards_to_generate = card.ability.extra.cards_to_generate + (card.ability.extra.bam_bonus+1)
                for i = 1, 2 do
                    SMODS.add_card({set="Playing Card", no_edition=true, enhanced_poll=1.0, area = G.deck})
                end
                return {
                    message = "Crack!",
                    colour = G.C.RED,
                }
            end
        end
        if context.after then
            print(card.ability.extra.cards_to_generate)
            if (card.ability.extra.cards_to_generate or 0) > 0 then
                card.ability.extra.cards_to_generate = 0
                return {
                    message = "Cards Added!",
                    colour = G.C.ORANGE,
                }
            end
            card.ability.extra.cards_to_generate = 0
            return true
        end
    end
}

--[[
name: Placeholder 013
]]--
SMODS.Joker{
    key = "placeholder_013",
    config = {
        extra = {
            bam_bonus = 1,
        }
    },
    loc_txt = {
        ['name'] = 'Placeholder 013',
        ['text'] = {
            [1] = '{V:1}Stone cards{} also',
            [2] = 'give {X:chips,C:white}x#1#{} Chips',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        },
    },
    cost = 4,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 4, y = 2 },
    pools = { ["bam_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        return {vars = {(1+(card.ability.extra.bam_bonus*0.25)),colours = { HEX('99a2b3') }}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if SMODS.get_enhancements(context.other_card)["m_stone"] == true then
                return {
                    x_chips = (1+(card.ability.extra.bam_bonus*0.25))
                }
            end
        end
    end
}

--[[
name: Placeholder 014
]]--
SMODS.Joker{
    key = "placeholder_014",
    config = {
        extra = {
            bam_bonus = 1,
            tags_gained = 0
        }
    },
    loc_txt = {
        ['name'] = 'Placeholder 014',
        ['text'] = {
            [1] = 'This joker permanently gains',
            [2] = '{C:mult}+#1#{} Mult per {C:blue}Tag{} obtained',
            [3] = '{C:inactive}(Currently {}{C:mult}+#2#{}{C:inactive} Mult){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        },
    },
    cost = 4,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 5, y = 2 },
    pools = { ["bam_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        return {vars = {(card.ability.extra.bam_bonus+2), (card.ability.extra.tags_gained * (card.ability.extra.bam_bonus+2))}}
    end,
    
    calculate = function(self, card, context)
        if context.tag_added  then
            card.ability.extra.tags_gained = card.ability.extra.tags_gained + 1

            return {
                message = "Mult Up!",
                colour = G.C.ORANGE,
            }
        end
        if context.cardarea == G.jokers and context.joker_main  then
            return {
                mult = card.ability.extra.tags_gained * (card.ability.extra.bam_bonus+2)
            }
        end
    end
}

--[[
name: Placeholder 015
]]--
SMODS.Joker{
    key = "placeholder_015",
    config = {
        extra = {
            bam_bonus = 1,
            shopping_total = 0,
        }
    },
    loc_txt = {
        ['name'] = 'Placeholder 015',
        ['text'] = {
            [1] = 'When you spend at least',
            [2] = '{C:money}$#1#{} total in a {C:green}Shop{},',
            [3] = 'gain a {C:blue}Coupon Tag{}',
            [4] = '{C:inactive}(Currently $#2#)',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        },
    },
    cost = 4,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 6, y = 2 },
    pools = { ["bam_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_TAGS.tag_coupon
        return {vars = {(card.ability.extra.bam_bonus*-5)+35, card.ability.extra.shopping_total}}
    end,
    
    calculate = function(self, card, context)
        if context.reroll_shop and context.cost > 0 then
            card.ability.extra.shopping_total = card.ability.extra.shopping_total + context.cost
            card:juice_up(0.3, 0.5)
            if card.ability.extra.shopping_total >= ((card.ability.extra.bam_bonus*-5)+35) then
                return {
                    message = "Threshold Met",
                    colour = G.C.ORANGE,
                }
            end
        end
        if context.buying_card then
            card.ability.extra.shopping_total = card.ability.extra.shopping_total + context.card.cost
            card:juice_up(0.3, 0.5)
            if card.ability.extra.shopping_total >= ((card.ability.extra.bam_bonus*-5)+35) then
                return {
                    message = "Threshold Met",
                    colour = G.C.ORANGE,
                }
            end
        end
        if context.open_booster then
            card.ability.extra.shopping_total = card.ability.extra.shopping_total + context.card.cost
            card:juice_up(0.3, 0.5)
            if card.ability.extra.shopping_total >= ((card.ability.extra.bam_bonus*-5)+35) then
                return {
                    message = "Threshold Met",
                    colour = G.C.ORANGE,
                }
            end
        end
        if context.ending_shop  then
            if card.ability.extra.shopping_total >= ((card.ability.extra.bam_bonus*-5)+35) then
                card.ability.extra.shopping_total = 0
                return {
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local tag = Tag("tag_coupon")
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
                    return true
                end,
                message = "Created Tag!",
                colour = G.C.GREEN
                }
            end
            card.ability.extra.shopping_total = 0
        end
    end
}

--[[
name: Placeholder 016
]]--
--globals
--[[G.GAME.j_bam_placeholder_016_source_rank = 2
G.GAME.j_bam_placeholder_016_target_rank = 3
SMODS.Joker{
    key = "placeholder_016",
    config = {
        extra = {
            bam_bonus = 1,
        }
    },
    loc_txt = {
        ['name'] = 'Placeholder 016',
        ['text'] = {
            [1] = 'Each #2# is instead',
            [2] = 'considered a #3#.',
            [3] = 'Ranks randomized on pickup',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        },
    },
    cost = 4,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Bamlatro',
    pos = { x = 7, y = 2 },
    pools = { ["bam_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        return {vars = {(card.ability.extra.bam_bonus), j_bam_placeholder_016_source_rank, j_bam_placeholder_016_target_rank}}
    end,
    
    calculate = function(self, card, context)
        if context.reroll_shop and context.cost > 0 then
            card.ability.extra.shopping_total = card.ability.extra.shopping_total + context.cost
            card:juice_up(0.3, 0.5)
            if card.ability.extra.shopping_total >= ((card.ability.extra.bam_bonus*-5)+35) then
                return {
                    message = "Threshold Met",
                    colour = G.C.ORANGE,
                }
            end
        end
        if context.buying_card then
            card.ability.extra.shopping_total = card.ability.extra.shopping_total + context.card.cost
            card:juice_up(0.3, 0.5)
            if card.ability.extra.shopping_total >= ((card.ability.extra.bam_bonus*-5)+35) then
                return {
                    message = "Threshold Met",
                    colour = G.C.ORANGE,
                }
            end
        end
        if context.open_booster then
            card.ability.extra.shopping_total = card.ability.extra.shopping_total + context.card.cost
            card:juice_up(0.3, 0.5)
            if card.ability.extra.shopping_total >= ((card.ability.extra.bam_bonus*-5)+35) then
                return {
                    message = "Threshold Met",
                    colour = G.C.ORANGE,
                }
            end
        end
        if context.ending_shop  then
            if card.ability.extra.shopping_total >= ((card.ability.extra.bam_bonus*-5)+35) then
                card.ability.extra.shopping_total = 0
                return {
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local tag = Tag("tag_coupon")
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
                    return true
                end,
                message = "Created Tag!",
                colour = G.C.GREEN
                }
            end
            card.ability.extra.shopping_total = 0
        end
    end
}
local card_get_id_ref = Card.get_id
function Card:get_id()
    local original_id = card_get_id_ref(self)
    if not original_id then return original_id end

    if next(SMODS.find_card("j_bam_placeholder_016")) then
        local source_ids = {j_bam_placeholder_016_source_rank}
        for _, source_id in pairs(source_ids) do
            if original_id == source_id then return 14 end
        end
    end
    return original_id
end]]--