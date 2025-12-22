-- Cheat Deck
SMODS.Back {
    key = "cheat",
    pos = { x = 0, y = 0 },
    config = { dollars = 9999999, hands = 99, discards = 99, joker_slot = 10 }, -- {voucher = 'v_crystal_ball', consumables = { 'c_fool', 'c_fool' }, spectral_rate = 2, }
    unlocked = true,
    loc_vars = function(self, info_queue, back)
        return { vars = { self.config.dollars, self.config.hands, self.config.discards, self.config.joker_slot } }
    end,
}