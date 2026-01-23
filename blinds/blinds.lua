SMODS.Blind {
    key = "bigmode",
    atlas = "BamlatroBlinds",
    pos = {
        x = 0,
        y = 0,
    },
    loc_txt = {
        name = 'Big Mode',
        text = {
            [1] = '{V:red}Extremely large blind.',
            [2] = 'When defeated, gain',
            [3] = '{C:blue}6 random Tags{}.',
        }
    },
    discovered = true,
    dollars = 5,
    mult = 10,
    boss = {min = 1},
    boss_colour = G.C.RED,

    defeat = function(self)
        local times = 6
        for i = 1, times do
            G.E_MANAGER:add_event(Event({
                func = function()
                    local selected_tag = pseudorandom_element(G.P_TAGS, pseudoseed("create_tag")).key
                    local tag = Tag(selected_tag)
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
    end
}

SMODS.Blind {
    -- 9DR76G5P   45 76 100 156
    key = "lockin",
    atlas = "BamlatroBlinds",
    pos = {
        x = 0,
        y = 0,
    },
    vars = {
        timestamp = 0,
        defeated = false,
    },
    loc_txt = {
        name = 'Lock In',
        text = {
            [1] = 'Game Over if not Defeated',
            [2] = 'within 60 seconds.',
            [3] = 'When Defeated, gain an',
            [4] = 'additional Joker Slot.',
        }
    },
    discovered = true,
    dollars = 10,
    mult = 2,
    boss = {min = 1},
    boss_colour = G.C.RED,

    set_blind = function(self)
        self.vars.defeat = false
        self.vars.timestamp = os.date("*t", os.time()).sec + (60 * os.date("*t", os.time()).min) + (3600 * os.date("*t", os.time()).hour) + (86400 * os.date("*t", os.time()).day)
        for i = 1, 60 do
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                blocking = false,
                blockable = false,
                delay = i * G.SETTINGS.GAMESPEED,
                func = function()
                    if self.vars.defeat == false then
                        if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.HAND_PLAYED then
                            -- ticking
                            if i % 2 == 1 then
                                play_sound('bam_sfx_tick', 1.0, 1)
                            end
                            if i % 2 == 0 then
                                play_sound('bam_sfx_tick', 0.8, 1)
                            end
                            
                            -- warning gongs
                            if i == 38 or i == 42 or i == 46 then
                                play_sound('bam_sfx_gong', 0.8, 1)
                            end
                            if i == 50 or i == 51 or i == 52 or i == 53 or i == 54 or i == 55 or i == 56 or i == 57 or i == 58 or i == 59 then
                                play_sound('bam_sfx_gong', 0.8 + (-0.2*(50-i)), 1)
                            end

                            -- expire
                            if i == 60 then
                                play_sound('bam_sfx_gong', 0.4, 1)
                            end
                        end
                    end
                    return true
                end
            }))
        end
    end,

    press_play = function(self)
        local timenow = os.date("*t", os.time()).sec + (60 * os.date("*t", os.time()).min) + (3600 * os.date("*t", os.time()).hour) + (86400 * os.date("*t", os.time()).day)
        if timenow - self.vars.timestamp > 60 then
            G.E_MANAGER:add_event(Event({
                trigger = "immediate",
                blocking = false,
                blockable = false,
                func = function()
                    G.GAME.chips = 0
                    G.STATE = G.STATES.HAND_PLAYED
                    G.STATE_COMPLETE = true
                    end_round()
                    return true
                end
            }))
        end
    end,

    defeat = function(self)
        self.vars.defeat = true
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
    end
}

SMODS.Blind {
    key = "placeholder_001",
    atlas = "BamlatroBlinds",
    pos = {
        x = 0,
        y = 0,
    },
    vars = {
        timestamp = 0,
        defeated = false,
    },
    loc_txt = {
        name = 'Placeholder 001',
        text = {
            [1] = 'All Non-Face cards',
            [2] = 'are debuffed.',
            [3] = 'When defeated, gain',
            [4] = 'two Consumable Slots.',
        }
    },
    discovered = true,
    dollars = 5,
    mult = 2,
    boss = {min = 1},
    boss_colour = G.C.RED,

    recalc_debuff = function(self, card, from_blind)
        for i = 2, 10 do
            if card:get_id() == i then
                return true
            end
        end
        if card:get_id() == 14 then
            return true
        end
        return false
    end,

    defeat = function(self)
        G.consumeables.config.card_limit = G.consumeables.config.card_limit + 2
    end
}

SMODS.Blind {
    key = "placeholder_002",
    atlas = "BamlatroBlinds",
    pos = {
        x = 0,
        y = 0,
    },
    vars = {
        timestamp = 0,
        defeated = false,
    },
    loc_txt = {
        name = 'Placeholder 002',
        text = {
            [1] = 'Jokers shuffled every',
            [2] = 'hand before scoring.',
            [3] = 'When defeated, 4 cards',
            [4] = 'become polychrome.',
        }
    },
    discovered = true,
    dollars = 5,
    mult = 2,
    boss = {min = 1},
    boss_colour = G.C.RED,

    press_play = function(self)
         if #G.jokers.cards > 1 then
            G.jokers:unhighlight_all()
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.jokers:shuffle('aajk')
                            play_sound('cardSlide1', 0.85)
                            return true
                        end,
                    }))
                    delay(0.15)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.jokers:shuffle('aajk')
                            play_sound('cardSlide1', 1.15)
                            return true
                        end
                    }))
                    delay(0.15)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.jokers:shuffle('aajk')
                            play_sound('cardSlide1', 1)
                            return true
                        end
                    }))
                    delay(0.5)
                    return true
                end
            }))
            end
    end,

    defeat = function(self)
        local deck_size = #G.deck.cards
        print("deck size")
        print(deck_size)
        local poly_converted = 0
        local index_tried = {}

        -- try to find random non-poly cards to convert
        while poly_converted < 4 and #index_tried < 100 do
            local random_index = math.ceil(math.random() * deck_size)

            local try_it = true
            for i = 0, #index_tried do
                if index_tried[i] == random_index then
                    try_it = false
                    break
                end
            end
            table.insert(index_tried, random_index)
            
            if try_it then
                print("random index")
                print(tostring(random_index) .. "\t" .. G.deck.cards[random_index].base.suit .. "\t" .. tostring(G.deck.cards[random_index]:get_id()))
                if G.deck.cards[random_index].edition then
                    print(G.deck.cards[random_index].edition.key)
                end
                if G.deck.cards[random_index].edition and G.deck.cards[random_index].edition.key == "e_polychrome" then
                    print("already")
                else
                    print("convert")
                    G.deck.cards[random_index]:set_edition("e_polychrome", true)
                    poly_converted = poly_converted + 1
                end
            end
        end

        -- eventually find non-poly cards linerarly if random is taking too long
        local i = 0
        while poly_converted < 4 and i < #G.deck.cards do
            print("manual search")

            local try_it = true
            for i = 0, #index_tried do
                if index_tried[i] == random_index then
                    try_it = false
                    break
                end
            end
            table.insert(index_tried, i)

            if try_it then
                if G.deck.cards[i].edition.key ~= "e_polychrome" then
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 0.15 * G.SETTINGS.GAMESPEED,
                        func = function()
                            G.deck.cards[random_index]:set_edition("e_polychrome", true)
                            return true
                        end,
                    }))
                    poly_converted = poly_converted + 1
                end
            end

            i = i + 1
        end
        print("---------------------")
    end
}

SMODS.Blind {
    key = "placeholder_003",
    atlas = "BamlatroBlinds",
    pos = {
        x = 0,
        y = 0,
    },
    vars = {
        timestamp = 0,
        defeated = false,
    },
    loc_txt = {
        name = 'Placeholder 003',
        text = {
            [1] = 'Only \'X of a Kind\'',
            [2] = 'hand types allowed.',
            [3] = 'When defeated, shop',
            [4] = 'gains extra card slot',
        }
    },
    discovered = true,
    dollars = 5,
    mult = 2,
    boss = {min = 1},
    boss_colour = G.C.RED,



    defeat = function(self)
        change_shop_size(1)
    end,

    debuff_hand = function(self, cards, hand, handname, check)
        return (handname == "High Card" or handname == "Pair" or handname == "Two Pair" or handname == "Straight" or handname == "Flush" or handname == "Full House" or handname == "Straight Flush" or handname == "Flush House")
    end
}