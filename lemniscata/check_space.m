% riceve in ingresso un vettore di configurazioni res, il cell array A
% dalla tabella D-H e verifica che le configurazioni siano nei limiti di
% spazio consentiti. 
% DA OTTIMIZZARE 


function correct = check_space(res,A)
syms q [6 1];

T03 = A{1,1}*A{1,2}*A{1,3};
T04 = A{1,1}*A{1,2}*A{1,3}*A{1,4};
T06 = A{1,1}*A{1,2}*A{1,3}*A{1,4}*A{1,5}*A{1,6};

correct = [];
for i = 1 : size(res,2)
  correct(i) = 1;
  % terna 3
  T03_i = double(eval(subs(T03,[q1; q2; q3],res(1:3,i))));
  if T03_i(3,4) < 0 && correct(i) == 1
      correct(i) = 0;
  end

  % terna 4
  T04_i = double(eval(subs(T04,[q1; q2; q3; q4],res(1:4,i))));
  if T04_i(3,4) < 0 && correct(i) == 1
      correct(i) = 0;
  end 

  % terna 5
  T06_i = double(eval(subs(T06,[q1; q2; q3; q4; q5; q6],res(1:6,i))));
  if T06_i(3,4) < 0 && correct(i) == 1
      correct(i) = 0;
  end 
    
end