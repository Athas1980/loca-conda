function make_snake(n)
    -- enemy snake starting locations
    local xcords = {23,18,11,6}
    local s = {}
    s.enemy = true
    s.tail = coords(xcords[n], 1)
	s.head = coords(xcords[n], 2)
	s.drawn=2
	s.hist={down}
	s.dir=down
	s.num = n
	if (n > 0 and levels[level.num].es) then
		s.len = levels[level.num].es[n]
	else 
		s.len=0
	end
    s.hist = {down}
    -- the next cell this will move to
    s.next = function(self)
        return self.head:plus(self.dir)
    end
	s.move = function(self, dir)
		local affected = {}
		if (dir == nill) return affected
		local old = self.hist[#self.hist]
		self.dir = dir
        self.drawn += 1
        while self.drawn > self.len do
			add(affected, {self.tail,0})
			self.tail=self.tail:plus(self.hist[1])
			deli(self.hist, 1)
			self.drawn-=1 
		end
		add(affected, {self.tail, self:tail_sprite()})
		add(self.hist, dir)
		add(affected, {self.head, self:get_body_sprite(old, dir)})
		self.head = self.head:plus(dir)
		add(affected, {self.head, self:head_sprite()})
		return affected
	end
	s.blank = function(self)
		local current = self.tail
		local removed = {{current,0}}
		for i=1, #self.hist do
			current = current:plus(self.hist[i])
			add(removed, {current,0})
		end
		return removed
	end
	s.get_body_sprite = function(self, old_dir, new_dir)
		local offset = 0
		
		if self.enemy then 
			offset = 4 
		end
		local bodyspr= 65+new_dir*16+offset
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
	
		return lookup[old_dir][new_dir]+offset
	
	end
	s.head_sprite = function (self) 
		local offset = 0
		
		if self.enemy then 
			offset = 4 
		end
		return 66 + offset + (self.dir)*16
	end
	s.tail_sprite = function(self)
		local offset = 0 if (self.enemy) offset=4
		return 64 + offset + (self.hist[1])*16
	end
	return s
end

function make_player() 
    local p = make_snake(0)
	p= reset_player(p)
	p.score =0
	p.lives =5
	return p
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