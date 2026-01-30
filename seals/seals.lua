SMODS.Seal{
    key = "spam",
    loc_txt = {
        ['name'] = 'Spam',
        ['text'] = {
            [1] = 'When scored, {c:green}#1# in #2#{} chance',
            [2] = 'to duplicate this card',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.',
        },
        ["label"] = 'Spam',
    },
    atlas = "BamlatroEnhancements",
    pos = { x = 0, y = 0 },
    config = {
        extra = {
            odds = 6,
        }
    },
    sound = { sound = 'gold_seal', per = 1.2, vol = 1 },

    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, self.config.extra.odds, 's_bam_spam') 
        return {vars = {new_numerator, new_denominator}}
    end,

    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            if SMODS.pseudorandom_probability(card, 'group_0_344f8d99', 1, self.config.extra.odds, 's_bam_spam', false) then
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local copied_card = copy_card(card, nil, nil, card)
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
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Copied!", colour = G.C.TAROT})
            end
        end
    end
}