function z = func1(t)
    if t >0.008856
        z = t^(1/3);
    else 
        z = 7.787*t +(16/116);
    end
end