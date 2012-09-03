-- modgcode.lua
-- (c) 2011 P. Brier, pbrier.nl /.at./ gmail.com 
--
-- change speed and extrusion in gcode file
-- Remove unwanted G and M codes
-- P.Brier  -- pbrier.nl/.at./gmail.com
--
-- use: lua modgcode.lua <speed> <extrude> <exclude1,exclude2,...>  < inputfile.gcode > outputfile.gcode
--
-- <Speed> and <extrude> [%] change printing speed and extrusion volume in percentage (100 is no change)
--
speed = 1.0;
extrusion = 1.0;
exclude = {};


-- get command line arguments 
if arg[1] ~= nil then speed = arg[1]/100.0;  end;    -- speed override
if arg[2] ~= nil then extrusion = arg[2]/100.0;  end -- extrusion override
if arg[3] ~= nil then 
  for w in string.gmatch(arg[3], ",*(%w+)") do
    table.insert(exclude,w);
  end
end

-- for all lines in the file, change the E and F values, and remove unwanted code lines
for s in io.lines() do
  doprint = s:len() > 1;
    if  s:find("F")  then
    s = s:gsub("F([%d%-%.]+)", function (n) return "F"..(n*speed) end) 
  end
  if  s:find("E") ~= nil  then
    s = s:gsub("E([%d%-%.]+)", function (n) return "E"..(n*extrusion) end)
    end
    for i,e in ipairs(exclude)  do
      if s:find(e) then
        doprint = false;
    end
  end
  if doprint then 
    print(s)
  end;
end

