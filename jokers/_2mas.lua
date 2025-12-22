
SMODS.Joker{ --2Mas
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
    pos = {
        x = 0,
        y = 0
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
    atlas = 'CustomJokers',
    pools = { ["bamboozl_mycustom_jokers"] = true },
    soul_pos = {
        x = 1,
        y = 0
    },
    
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