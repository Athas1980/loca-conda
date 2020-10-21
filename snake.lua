

---- DELETE ----
up,down,left,right = 1,2,3,4
function coords(x,y)
    return {
      x = x, y = y,
      plus=function(self,dir)
        local x1, y1 = x,y
        if(dir==up) y1-=1
        if (dir==down) y1+=1
        if (dir==left) x1-=1
        if (dir==right) x1+=1
        return coords(x1, y1)
       end
    }
end

levels = {
	{
		d1 = 10,
		delay = 6,
		es = {6}
	},
	{
		d2 =10,
		d4 = 5,
		acid = 5,
		delay = 5
	},
	{
		d4 = 5,
		d5 = 5,
		acid = 8,
		delay = 5,
	},{
		d2 = 30,
		d10 = 2,
		l=2
	},
	{ d1=10, d2=5, d4=5, d5=5, d10=3, acid=10},
	{ d1=20, d10=5, delay=3, l=2},
	{ d4 =5, d1= 10, es={20}}
}

level = {}
level.num = 1
-----



function make_snake(n)
    -- enemy snake starting locations
    local xcords = {23,18,11,6}
    local s = {}
    s.enemy = true
    s.tail = coords(xcords[n], 1)
	s.head = coords(xcords[n], 2)
	s.drawn=2
	s.dir=down
	s.len = levels[level.num].es[n]
    s.hist = {down}
    -- the next cell this will move to
    s.next = function(self)
        return self.head.plus(self.dir)
    end
    s.move = function(self, dir)
		local affected = {}
		local old = self.hist[#self.hist]
        self.drawn += 1
        while self.drawn > self.len do
			add(affected, {self.tail,0})
			self.tail=self.tail:plus(self.hist[2])
			deli(self.hist, 1)
			self.drawn-=1 
		end
		printh("affected len " .. #affected)
		add(affected, {self.head, self:get_body_sprite(old, dir)})
		printh("affected len " .. #affected)
		self.head = self.head:plus(dir)
		add(affected, {self.head, self:head_sprite()})
		return affected
        
	end
	s.get_body_sprite = function(self, old_dir, new_dir)

		local offset = 0
		
		if self.enemy then 
			offset = 4 
		end
		local bodyspr= 49+new_dir*16+offset
		if(old_dir == new_dir) return bodyspr
	
		local lookup={}
		lookup[up]={}
		lookup[down]={}
		lookup[left]={}
		lookup[right]={}
		lookup[up][left]= 83
		lookup[up][right]= 115
		lookup[down][left] = 99
		lookup[down][right] = 67
		lookup[left][up] = 67
		lookup[left][down] = 115
		lookup[right][up] = 99
		lookup[right][down] = 83
	
		return lookup[old_dir][new_dir]
	
	end
	s.head_sprite = function (self) 
		local offset = 0
		
		if self.enemy then 
			offset = 4 
		end
		return 66 + (self.dir-1)*16
	end
    return s
end

function make_player() 
    local p = make_snake(0)
    return reset_player(p)
end

function reset_player(p)
    p.enemy = false
	p.ctrl = 3
	p.head= coords(1,3)
	p.tail= coords(1,1)
	p.dir=down
	p.drawn=3
	p.len=6
	p.hist = {down, down}
	return p
end