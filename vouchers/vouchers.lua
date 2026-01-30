SMODS.Voucher {
    key = 'starterpackA',
    loc_txt = {
        ['name'] = 'Starter Pack',
        ['text'] = {
            [1] = 'Sell all jokers. Gain',
            [2] = '2 random consumables and',
            [3] = '4 enhanced playing cards.',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    atlas = 'BamlatroVouchersAnimated',
    pos = { x = 0, y = 0 },
    cost = 0,

    redeem = function(self, card)

        -- find all destructable jokers
        local destructable_jokers = {}
        for i, joker in ipairs(G.jokers.cards) do
            if joker ~= card and not SMODS.is_eternal(joker) and not joker.getting_sliced then
                table.insert(destructable_jokers, joker)
            end
        end

        -- gain money equal to sum of destructable jokers sell values
        --if #destructable_jokers > 0 then
        local current_dollars = G.GAME.dollars
        local joker_values = 0
        for i, joker in ipairs(destructable_jokers) do
            joker_values = joker_values+ joker.sell_cost
        end
        local target_dollars = G.GAME.dollars + joker_values
        ease_dollars(dollar_value)

        -- destroy destructable jokers
        for i, target_joker in ipairs(destructable_jokers) do
            target_joker.getting_sliced = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    target_joker:start_dissolve({G.C.MONEY}, nil, 1.6)
                    return true
                end
            }))
        end
        --end

        -- gain two random taror/spectral cards
        for i = 1, math.min(2, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    local random_set = pseudorandom_element({"Tarot", "Spectral"}, pseudoseed('add_card_hand_enhancement'))
                    play_sound('timpani')
                    SMODS.add_card({ set = random_set})                            
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end

        -- gain 4 random enhanced playing cards
        delay(0.6)
        for i = 1, 4 do
            local card_front = pseudorandom_element(G.P_CARDS, pseudoseed('add_card_hand'))
            local base_card = create_playing_card({
                front = card_front,
                center = pseudorandom_element({G.P_CENTERS.m_gold, G.P_CENTERS.m_steel, G.P_CENTERS.m_glass, G.P_CENTERS.m_wild, G.P_CENTERS.m_mult, G.P_CENTERS.m_lucky, G.P_CENTERS.m_stone}, pseudoseed('add_card_hand_enhancement'))
            }, G.discard, true, false, nil, true)
            
            
            
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            local new_card = copy_card(base_card, nil, nil, G.playing_card)
            
            new_card:add_to_deck()
            
            G.deck.config.card_limit = G.deck.config.card_limit + 1
            G.deck:emplace(new_card)
            table.insert(G.playing_cards, new_card)
            
            base_card:remove()
            
            G.E_MANAGER:add_event(Event({
                func = function() 
                    new_card:start_materialize()
                    return true
                end
            }))
        end

        -- TODO: REMOVE THIS CHEAT
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.add_card({key="j_bootstraps"})
                SMODS.add_card({key="j_bull"})
                return true
            end
        }))
    end,

    in_pool = function(self, args)
        return G.GAME.ante == 1
    end
}

SMODS.Voucher {
    key = 'starterpackB',
    loc_txt = {
        ['name'] = 'Starter Pack',
        ['text'] = {
            [1] = 'Sell all jokers. Gain',
            [2] = '2 random Bamlatro jokers.',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    atlas = 'BamlatroVouchersAnimated',
    pos = { x = 0, y = 0 },
    cost = 0,

    redeem = function(self, card)

        -- find all destructable jokers
        local destructable_jokers = {}
        for i, joker in ipairs(G.jokers.cards) do
            if joker ~= card and not SMODS.is_eternal(joker) and not joker.getting_sliced then
                table.insert(destructable_jokers, joker)
            end
        end

        -- gain money equal to sum of destructable jokers sell values
        --if #destructable_jokers > 0 then
        local current_dollars = G.GAME.dollars
        local joker_values = 0
        for i, joker in ipairs(destructable_jokers) do
            joker_values = joker_values+ joker.sell_cost
        end
        local target_dollars = G.GAME.dollars + joker_values
        ease_dollars(dollar_value)

        -- destroy destructable jokers
        for i, target_joker in ipairs(destructable_jokers) do
            target_joker.getting_sliced = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    target_joker:start_dissolve({G.C.MONEY}, nil, 1.6)
                    return true
                end
            }))
        end
        --end

        -- gain two random Bamlatro jokers
        for i = 1, 2 do
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.add_card({ set = 'bam_jokers' })
                    return true
                end
            }))
            -- TODO: REMOVE THIS CHEAT
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.add_card({key="j_bootstraps"})
                    SMODS.add_card({key="j_bull"})
                    return true
                end
            }))
        end
    end,

    in_pool = function(self, args)
        return G.GAME.ante == 1
    end
}


SMODS.Voucher {
    key = 'placeholder_005',
    loc_txt = {
        ['name'] = 'Placeholder 005',
        ['text'] = {
            [1] = 'Uncommon and rare jokers appear {C:attention}2X{}',
            [2] = 'more frequently in the shop.',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    atlas = 'BamlatroVouchers',
    pos = { x = 0, y = 0 },
    cost = 0,

    redeem = function(self, card)
        SMODS.calculate_effect({
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.common_mod = math.max(0.05, G.GAME.common_mod - 0.2)
                    G.GAME.uncommon_mod = G.GAME.uncommon_mod + 0.15
                    G.GAME.rare_mod = G.GAME.rare_mod + 0.05
                    return true
                end
            }))
        }, card)
    end
}

SMODS.Voucher {
    key = 'placeholder_006',
    loc_txt = {
        ['name'] = 'Placeholder 006',
        ['text'] = {
            [1] = 'Rare jokers appear {C:attention}4X{}',
            [2] = 'more frequently in the shop.',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    atlas = 'BamlatroVouchers',
    pos = { x = 0, y = 0 },
    cost = 0,
    requires = {"v_bam_placeholder_005"},

    redeem = function(self, card)
        SMODS.calculate_effect({
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.common_mod = math.max(0.05, G.GAME.common_mod - 0.1)
                    G.GAME.rare_mod = G.GAME.rare_mod + 0.1
                    return true
                end
            }))
        }, card)
    end
}

SMODS.Voucher {
    key = 'placeholder_007',
    loc_txt = {
        ['name'] = 'Placeholder 007',
        ['text'] = {
            [1] = 'Legendary spectrals appear {C:attention}4X{}',
            [2] = 'more frequently in spectral packs.',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    atlas = 'BamlatroVouchers',
    pos = { x = 0, y = 0 },
    cost = 10,

    redeem = function(self, card)
        SMODS.calculate_effect({
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.legendary_spectral_bonus = G.GAME.legendary_spectral_bonus * 5
                    return true
                end
            }))
        }, card)
    end
}

SMODS.Voucher {
    key = 'placeholder_008',
    loc_txt = {
        ['name'] = 'Placeholder 008',
        ['text'] = {
            [1] = 'Legendary spectrals appear {C:attention}16X{}',
            [2] = 'more frequently in spectral packs.',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    atlas = 'BamlatroVouchers',
    pos = { x = 0, y = 0 },
    cost = 10,
    requires = {"v_bam_placeholder_007"},

    redeem = function(self, card)
        SMODS.calculate_effect({
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.legendary_spectral_bonus = G.GAME.legendary_spectral_bonus * 5
                    return true
                end
            }))
        }, card)
    end
}

