x = [0 0 1 1 1 1 2 4 5 7 9 0 0 0 0]
xrec = 0;
for i = 2:15
    a = ex2_5(x(i),xrec)
    xrec = a(6);
end