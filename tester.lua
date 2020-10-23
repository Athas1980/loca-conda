--dependency
#include coords.lua
--File containing code being tested
#include snake.lua

-- constants used by code
up,down,left,right=1,2,3,4

levels = {
	{
		d1 = 10,
		delay = 6,
		es = {6}
    }
}
level = {}
level.num = 1
------------

-- local constants
up_tail, up_body, up_head, ur_block = 64, 65, 66, 115
dn_tail, dn_body, dn_head, dl_block = 80, 81, 82, 99
lt_tail, lt_body, lt_head, ul_block = 96, 97, 98, 83
rt_tail, rt_body, rt_head, dr_block = 112, 113, 114, 67
--

local sut
function before_each()
    sut = make_player()
end

tests = {
    ["new player head"]= function()
        assert(sut.head.x==1 and sut.head.y==3, "head should be at 1,3")
    end,
    ["new player tail"]= function()
        assert(sut.tail.x==1 and sut.tail.y==1, "tail should be at 1,1")
    end,
    ["new player drawn"] = function()
        assert(sut.len == 6, "should have a desired length of six")
        assert(sut.drawn == 3, "should have an actual length of 3")
    end,
    ["move adds to drawn"] = function()
        sut:move(down)
        assert(sut.drawn == 4, "should have an actual length of 4")
        assert(sut.len == 6, "should have a desired length of six")
        assert(sut.tail.x==1 and sut.tail.y ==1, "tail should not have moved")
    end,
    ["move returns sprites for new and old head"] = function()
        local result = sut:move(down)
        assert(#result == 2, "should have two entries")
        assert_old_head(result, 1, 3, dn_body)
        assert_head(result, 1, 4, dn_head)
    end,
    ["body down to left"] = function()
        local result = sut:move(left)
        assert_old_head(result, 1, 3, dl_block)
        assert(result, 0, 3, lt_head)
    end,
    ["body down to right"] = function()
        local result = sut:move(right)
        assert_old_head(result, 1, 3, dr_block)
        assert(result, 0, 3, rt_head)
    end,
    ["body left to left"] = function()
        sut:move(right)
        sut:move(right)
        sut:move(down)
        sut:move(left)
        result = sut:move(left)
        assert_old_head(result,2,4,lt_body)
        assert_head(result,1,4,lt_head)
    end,
    ["body left to up"] = function()
        sut:move(left)
        result = sut:move(up)
        assert_old_head(result,0,3,dr_block)
        assert_head(result,0,2,up_head)
    end,
    ["body left to down"] = function()
        sut:move(left)
        result = sut:move(down)
        assert_old_head(result,0,3,ur_block)
        assert_head(result,0,4,dn_head)
    end,
    ["body right to right"] = function()
        sut:move(right)
        result = sut:move(right)
        assert_old_head(result,2,3,rt_body)
        assert_head(result,3,3,rt_head)
    end,
    ["body right to down"] = function()
        sut:move(right)
        result = sut:move(down)
        assert_old_head(result,2,3,ul_block)
        assert_head(result,2,4,dn_head)
    end,
    ["body right to up"] = function()
        sut:move(right)
        result = sut:move(up)
        assert_old_head(result,2,3,dl_block)
        assert_head(result,2,2,up_head)
    end,
    ["blank returns all cells"] = function()
        sut:move(right)
        sut:move(down)
        sut:move(right)
        sut:move(down)
        result = sut:blank()
        assert(#result == 6, "Should have same number of cells as the max snake length")
        assert_sprite_coord(result[1], 1,2,0)
        assert_sprite_coord(result[2], 1,3,0)
        assert_sprite_coord(result[3], 2,3,0)
        assert_sprite_coord(result[4], 2,4,0)
        assert_sprite_coord(result[5], 3,4,0)
        assert_sprite_coord(result[6], 3,5,0)
    end


}

function assert_old_head(tab, x, y, sprite) 
    local old_head = tab[#tab-1]
    assert_sprite_coord(old_head,x,y,sprite)
end

function assert_head(tab, x, y, sprite)
    local head = tab[#tab]
    assert_sprite_coord(head,x,y,sprite)
end

function assert_sprite_coord(tab, x, y, sprite)
    assert(tab[1].x ==x and tab[1].y == y and tab[2]==sprite, "expected x:"..x..", y:"..y..", sprite:"..sprite.." got x:"..tab[1].x..", y:"..tab[1].y..",sprite:"..tab[2])
end

local successes = 0
local failures = 0
for test, fun in pairs(tests) do
    if(before_each and type(before_each) == 'function') before_each()
    printh(test)
    local co = cocreate(fun)
    local success, error = coresume(co)
    if success then 
        printh("PASS")
        successes+=1
    else 
        printh("FAIL")
        print("fail - "..test)
        printh(error)
        failures+=1
    end
end
printh("")
printh("-------")
printh("PASS/TOTAL "..successes.."/"..failures+successes)

print ("PASS/TOTAL "..successes.."/"..failures+successes)