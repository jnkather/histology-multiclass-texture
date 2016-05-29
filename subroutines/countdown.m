% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file, includes disclaimer

function countdown(N)

    for i = fliplr(1:N)
        disp(num2str(i)), pause(0.05);
    end

end

