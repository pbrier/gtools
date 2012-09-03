-- gmeasure.lua
-- (c) 2011 P. Brier, pbrier.nl /.at./ gmail.com 
--
-- measure gcode stats
--
-- use: lua gmeasure.lua 
--
-- for each line we calculate DX,DY,DE, SQRT(DX^2,DY^2) and SQRT(DX^2,DY^2)/DE
--
--
x=0;
y=0;
z=0;
e=0;
f=0;

px=0;
py=0;
pz=0;
pe=0;


-- for all lines in the file, read x,y,e value
for s in io.lines() do
  if s == nil then
    break;
  end;
  if  string.find(s,"X") ~= nil then
    string.gsub(s,"X([%d%-%.]+)", function (n) x=n end) 
  end
  if string.find(s,"Y") ~= nil then
    string.gsub(s,"Y([%d%-%.]+)", function (n) y=n end) 
  end
  if  string.find(s,"E") ~= nil then
    string.gsub(s,"E([%d%-%.]+)", function (n) e=n end) 
  end

  -- print(x .. " " .. y .. " " .. z .. " " .. e)
  if  string.find(s,"G1") ~= nil then
    print(x-px .. " " .. y-py .. " " .. e-pe)
  end;
  px=x;
  py=y;
  pz=z;
  pe=e;
end

