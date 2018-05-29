%VPPM encoder

%sinal binário
fileId = fopen('rom.bin');
x = fscanf(fileId,'%f');

signalLength = length(x);

vppmEncoder= zeros(1, signalLength-1);

for i=1:2:signalLength-1
    if (x(i) == 0)
    vppmEncoder(i) = 1;
    else
    vppmEncoder(i) = 0;
    end
    
    vppmEncoder(i+1) = ~vppmEncoder(i);
end

plot(1:1:4096,vppmEncoder)
axis([0 100 0 1.1])


%if(x)

fclose(fileId);