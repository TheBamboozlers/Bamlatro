SMODS.Consumable {
    key = 'taptheglass',
    set = 'Spectral',
    loc_txt = {
        name = 'Tap The Glass',
        text = {
            [1] = 'Applies {C:purple}Bamboozled{} to',
            [2] = 'selected {X:legendary,C:white}Bamlatro{} Joker.'
        }
    },
    cost = 10,
    unlocked = true,
    discovered = true,
    soul_set = 'Spectral',
    soul_rate = 1,
    hidden = true,
    can_repeat_soul = true,
    soul_set = 'Spectral',
    atlas = 'Bamlatro',
    pos = { x = 2, y = 3 },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_bam_bamboozled
        return {vars = {}}
    end,

    use = function(self, card, area, copier)
        local used_card = copier or card
        if #G.jokers.highlighted == 1 then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    used_card:juice_up(0.3, 0.5)
                    return true
                end
            }))
            --local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    
                    G.jokers.highlighted[1]:flip()
                    play_sound('card1', 1)
                    G.jokers.highlighted[1]:juice_up(0.3, 0.3)
                    return true
                end
            }))
            delay(0.2)
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    
                    G.jokers.highlighted[1]:set_edition("e_bam_bamboozled", true)
                    return true
                end
            }))
            
            --local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.jokers.highlighted[1]:flip()
                    play_sound('tarot2', 1, 0.6)
                    G.jokers.highlighted[1]:juice_up(0.3, 0.3)
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    G.jokers:unhighlight_all()
                    return true
                end
            }))
            delay(0.5)
        end
    end,

    can_use = function(self, card)
        return (#G.jokers.highlighted == 1) -- and string.sub(G.jokers.highlighted.key,1,5) == "j_bam") -- TODO: FIX THIS
    end,

    in_pool = function(self, args)
        return math.random(1,(math.floor( 333 / G.GAME.legendary_spectral_bonus ))) == 1
    end
}