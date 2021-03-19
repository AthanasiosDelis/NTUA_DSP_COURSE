function result = ex2_5(x, x_rec_b)
x_bar = 0.8*x_rec_b;
d = x - x_bar;
if d >= 0 
    d_bar = 1;
    c = 0;
else
    d_bar = -1;
    c = 1;
end
x_rec = d_bar + x_bar;
result = [x x_bar d d_bar c x_rec];
end