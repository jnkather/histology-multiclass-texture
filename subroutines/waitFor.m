% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file in same folder, includes disclaimer

function waitFor(elapsedTime,maxTime)
      if elapsedTime>maxTime, elapsedTime = maxTime; end % max. pause = maxTime sec
      warning(['Pausing for ', num2str(elapsedTime), ' seconds...']);
      pause(elapsedTime); disp('continuing...'); 
end