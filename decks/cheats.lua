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
    config = { dollars = 9999999, hands = 99, discards = 99, joker_slot = 10, vouchers = {"v_overstock_norm", "v_overstock_plus"}}, -- {voucher = 'v_crystal_ball', consumables = { 'c_fool', 'c_fool' }, spectral_rate = 2, }
    unlocked = true,
    loc_vars = function(self, info_queue, back)
        return { vars = { self.config.dollars, self.config.hands, self.config.discards, self.config.joker_slot } }
    end,
}