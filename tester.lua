--File containing code being tested
#include snake.lua


local sut
function before_each
    sut = make_player()
end

tests = {
    ["new player head"]= function()
        assert(sut.head.x==3 and sut.head.y==1, "head should be at 3,1")
    end,
    ["new player drawn"] = function()
        assert(sut.len == 6, "should have a desired length of six")
        assert(sut.drawn == 3, "should have an actual length of 3")
    end,
}

for test, fun in pairs(tests) do
    if(before_each and type(before_each) == function) before_each()

    local co = cocreate(fun)
    local success, error = coresume(co)
    if success then 
        printh("PASS - "..test)
    else 
        printh("FAIL -".. test)
        printh(error)
    end
    printh()
end