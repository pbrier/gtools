-- gskip.lua
-- (c) 2011 P. Brier, pbrier.nl /.at./ gmail.com 
--
-- Skip layers from a GCODE file. 
-- a layer change is detected by the layer change cookie (for example a M2 command)
-- Make sure the E-coordinates are continuous (no skips because of deleted layers)
-- Skip count: nr of layers to skip when a layer change is dectected (1 will halve the nr of layers, 2 = 1/3, etc.)
--
-- P.Brier  -- pbrier.nl/.at./gmail.com
--
-- use: lua gskip.lua [file1.gcode] [skip count]
--
--
cookie = "M2"; -- we switch files based on this GCODE line
files = {};
names = {};
layer = 1;
layercount = 1;
skip = 1;
doskip = false;

e = 0; -- initial e
scale = 1; -- scale e coordinates

-- cmd line arguments
f = io.open(arg[1], "r");
skip = (arg[2] or skip)+0; -- ingnore nil, and coerce to number

-- read untill we see a cookie or EOF. Return true if EOF
function readfile()
  print("; file " .. arg[1] .. " converted with gskip.lua, layer skip value is " .. skip);  
  pe = 0; -- previous e
  skipcount = 1;
  while true do
    s = f:read("*line");
    if s == nil then 
      return true;
    end;
    if s:find("G1") then
	  s = s:gsub("E([%d%-%.]+)", function (n) if not doskip then e = e + (n-pe); end; pe = n; return "E".. e*scale;  end)
	end;
	if not doskip then
	  print(s); 
	end;	
	if s:find(cookie) then
	  layer = layer + 1;	  
	  skipcount = skipcount + 1;
	  if skipcount > skip then 
	    skipcount = 1;        
		doskip = not doskip;
		if not doskip then layercount = layercount + 1; end;
		print("; Next layer: " .. layer );
	  end;	  
	end;
	
  end
end;

readfile();

print("; END OF FILE, TOTAL=".. layer .. " Layers in input, " .. layercount .. " Layers in the output");