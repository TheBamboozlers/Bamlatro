SMODS.Back:take_ownership('b_red', {
    config = {
        discards = 1, 
        vouchers = {"v_directors_cut","v_retcon"},
        extra = {
            starterpack_spawned = false
        }
    },

    calculate = function(self, back, context)
        if context.starting_shop then
            if self.config.extra.starterpack_spawned == false then
                
                -- Set shop vouchers to 2
                local current_voucher_slots = (G.GAME.modifiers.extra_vouchers or 0)
                local target_voucher_slots = 2
                local difference = target_voucher_slots - current_voucher_slots
                SMODS.change_voucher_limit(difference)

                -- Add starter voucher to shop
                local voucher = pseudorandom_element({'v_bam_starterpackA','v_bam_starterpackB'}, 'starter vouch')
                SMODS.add_voucher_to_shop(voucher)
                self.config.extra.starterpack_spawned = true

                -- reset global variables
                G.GAME.legendary_spectral_bonus = 1
            end
        end
    end
},true)

-- TODO: take_owership off all vanilla decks so that they all have blind reroll vouchers

-- SPECTRAL version of Black Hole
SMODS.Consumable:take_ownership('c_black_hole', {

    soul_rate = 1,

    soul_set = "Spectral",
    
    in_pool = function(self, args)
        return math.random(1,(math.floor( 333 / G.GAME.legendary_spectral_bonus ))) == 1
    end

},true)

-- PLANET version of Black Hole (will display that its from BAM mod, but whatever)
SMODS.Consumable {
    key = 'black_hole',
    set = "Planet",
    loc_txt = {
        ['name'] = 'Black Hole',
        ['text'] = {
            [1] = 'Upgrade every',
            [2] = '{C:purple}poker hand{}',
            [3] = 'by {C:attention}1{} level',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    atlas = "Bamlatro",
    pos = { x = 2, y = 3 },
    cost = 10,
    hidden = true,
    soul_set = 'Planet',
    soul_rate = 1,
    can_repeat_soul = true,
    use = function(self, card, area, copier)
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
            { handname = localize('k_all_hands'), chips = '...', mult = '...', level = '' })
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = true
                return true
            end
        }))
        update_hand_text({ delay = 0 }, { mult = '+', StatusText = true })
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.9,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                return true
            end
        }))
        update_hand_text({ delay = 0 }, { chips = '+', StatusText = true })
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.9,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = nil
                return true
            end
        }))
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 }, { level = '+1' })
        delay(1.3)
        SMODS.upgrade_poker_hands({ instant = true })
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
            { mult = 0, chips = 0, handname = '', level = '' })
    end,
    can_use = function(self, card)
        return true
    end,
    --[[draw = function(self, card, layer)
        -- This is for the Spectral shader. You don't need this with `set = "Spectral"`
        -- Also look into SMODS.DrawStep if you make multiple cards that need the same shader
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' then
            card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
        end
    end,]]--

    in_pool = function(self, args)
        return math.random(1,(math.floor( 333 / (G.GAME.legendary_spectral_bonus or 1) ))) == 1
    end
}

SMODS.Consumable:take_ownership('c_soul', {

    soul_rate = 1,
    
    in_pool = function(self, args)
        return math.random(1,(math.floor( 333 / (G.GAME.legendary_spectral_bonus or 1) ))) == 1
    end

},true)

SMODS.Booster:take_ownership('p_spectral_normal_1', {
    weight = 1,
},true)
SMODS.Booster:take_ownership('p_spectral_normal_2', {
    weight = 1,
},true)
SMODS.Booster:take_ownership('p_spectral_jumbo_1', {
    weight = 1,
},true)
SMODS.Booster:take_ownership('p_spectral_mega_1', {
    weight = 0.3,
},true)