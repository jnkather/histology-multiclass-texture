% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file in same folder, includes disclaimer

function rgb = hex2rgb(hexString)

% expects a string that contains a hex code of a color. The string can have
% 6 characters (like 'FFFFFF') or 7 characters (like '#FFFFFF'). If the
% string contains 7 characters, the first is stripped. RGB is a
% three-element vector of the red, green, blue value in range 0...1

	if size(hexString,2) ~= 6
        if size(hexString,2) == 7
            % strip first character
            hexString = hexString(2:end);
        else
            error('invalid input: not 6 or 7 characters');
        end
    end    
	
    % hexString has 6 characters
	r = double(hex2dec(hexString(1:2)))/255;
	g = double(hex2dec(hexString(3:4)))/255;
	b = double(hex2dec(hexString(5:6)))/255;
	rgb = [r, g, b];
end