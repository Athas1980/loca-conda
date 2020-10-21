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
