% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file, includes disclaimer

function [myCmap, CatNamesShort] = tissueColorMap(numCol)

myCmap =      [hex2rgb('DE4714');...  % tumor
              hex2rgb('43A623');...  % stroma, simple
              hex2rgb('EDB409');...  % stroma, complex
              hex2rgb('1D90B8');...  % lympho
              hex2rgb('B82894');...  % debris
              hex2rgb('F2D0C4');...  % mucosa
              hex2rgb('888888');...  % adipose
              hex2rgb('333333')];    % background

CatNamesShort  = {'Tum','Str','Cmp','Lym','Dbr','Muc','Adi','Bgr'};

% restrict classes
myCmap((numCol+1):end,:) = [];
CatNamesShort((numCol+1):end) = [];

end