-- gmerge.lua
-- (c) 2011 P. Brier, pbrier.nl /.at./ gmail.com 
--
-- Merge multiple gcode files, layer by layer
-- a layer change is detected by the layer change cookie (for example a M2 command)
-- Make sure the E-coordinates are relative per layer, and the E-value is reset to zero each layer
-- otherwise they will be mixed up in the file
--
-- P.Brier  -- pbrier.nl/.at./gmail.com
--
-- use: lua gmerge.lua [file1.gcode] [file2.gcode] ... [filen.gcode]
--
--
cookie = "M2;"; -- we switch files based on this GCODE line
files = {};
names = {};
layer = 0;
etotal = 0;

-- read untill we see a cookie or EOF. Return true if EOF
function readfile(f, name)
  print("; file=" .. name);
  estart = nil;
  edelta = 0;
  while true do
    s = f:read("*line");
    if s == nil then 
	  etotal = etotal + edelta;	  
      return true; -- done  
    end;	
	if s:find(cookie) then -- we found our cookie: return. Note: line with cookie is not emitted in the output
	  etotal = etotal + edelta;	  
	  return false; -- not done yet with this file
	end;
	if s:find("G1") then
	  s = s:gsub("E([%d%-%.]+)", function (n) if estart == nil then estart = n-0.001; end; edelta = (n-estart); return "E".. etotal+edelta end)     
	end;
    print(s);  	
  end
end;

print("; merge files: ");
for i=1,table.getn(arg) do
  print(";   " .. arg[i] );
  files[i] = io.open(arg[i], "r");
  names[i] = arg[i];
end;

-- Start code
print("G92 X0 Y0 Z0 E0 ; Set all axis zero");
print("M601 S500  ; set pulse period [usec]");
print("M200 E100 ; set E scale [pulses/mm]");

-- loop for all files, untill they are all done
done = false;
while done == false do  
  done = true;
  for i,f in pairs(files) do
    -- print("G92 E0; set E back to zero for each file");
    if readfile(f, names[i]) == false then -- file not done?
	  done = false;
    end;	
  end;  
  layer = layer + 1;
  if (layer % 2) == 1 then
    print("M2; end of layer " .. layer); -- insert a new layer wait command
  end;
end;

print("; END OF FILES");