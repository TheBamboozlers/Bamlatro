-- Cheat Deck
SMODS.Back {
    name = "Cheat Deck",
    loc_txt = {
        name = "Cheat Deck",
        text = {
            "Use for testing.",
            "#1# dollars, #2# hands,",
            "#3# discards, #4# joker slots,",
            "overstock voucher & overstock plus",
        },
    },
    key = "cheat",
    atlas = "Bamlatro",
    pos = { x = 0, y = 0 },
    config = { 
        dollars = 9, 
        hands = 0, 
        discards = 99, 
        joker_slot = 10, 
        vouchers = {"v_overstock_norm", "v_overstock_plus", "v_directors_cut","v_retcon"}, -- {voucher = 'v_crystal_ball', 
        --consumables = { 'c_fool', 'c_fool' }, 
        --spectral_rate = 2,
        extra = {
            starterpack_spawned = false,
            begin_extra_voucher = false,
        }
    },

    unlocked = true,
    loc_vars = function(self, info_queue, back)
        return { vars = { self.config.dollars, self.config.hands, self.config.discards, self.config.joker_slot } }
    end,

    calculate = function(self, back, context)
        if context.starting_shop then

            if G.GAME.round == 1 then
                self.config.extra.begin_extra_voucher = false
                self.config.extra.starterpack_spawned = false

                -- reset global variables
                G.GAME.legendary_spectral_bonus = 1
                G.GAME.common_mod = 0.7
                G.GAME.uncommon_mod = 0.25
                G.GAME.rare_mod = 0.05



                SMODS.change_booster_limit(1)
            end
            
            if self.config.extra.begin_extra_voucher == true then
                -- Set shop vouchers to 2
                local current_voucher_slots = (G.GAME.modifiers.extra_vouchers or 0)
                local target_voucher_slots = 1
                local difference = target_voucher_slots - current_voucher_slots
                SMODS.change_voucher_limit(difference)
            end

            if self.config.extra.starterpack_spawned == false then

                -- Add starter voucher to shop
                local voucher = pseudorandom_element({'v_bam_starterpackA','v_bam_starterpackB'}, 'starter vouch')
                SMODS.add_voucher_to_shop(voucher)
                SMODS.add_voucher_to_shop("v_bam_placeholder_007")
                SMODS.add_voucher_to_shop("v_bam_placeholder_008")
                
                self.config.extra.starterpack_spawned = true
            end
        end

        if context.ante_change then
            self.config.extra.begin_extra_voucher = true
        end


    end

    --[[apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = "1",
            func = function()
                -- Set shop vouchers to 2
                local current_voucher_slots = (G.GAME.modifiers.extra_vouchers or 0)
                local target_voucher_slots = 2
                local difference = target_voucher_slots - current_voucher_slots
                --SMODS.change_voucher_limit(difference)

                -- Add starter voucher to shop
                SMODS.add_voucher_to_shop("v_bam_starterpack")
                return true
            end
            }))
    end]]--
}