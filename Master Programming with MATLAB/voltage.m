function x = voltage(V,R)
% see best solution at the end
    cons = [1.5 1.6 1.7].*V; %constant matrix with random values
    special_true = [false;false;false];    %matrix to check if special conditions exist and where
    for i=1:6
        if R(i)==0
            if rem(i,2)==0  %even resistors
                cons(i/2) = 0;    
            else
                cons((i+1)/2) = V; %odd resistors
            end
        end
    end
    a = cons(1); b = cons(2); c = cons(3);
    
    for i=1:3
        if cons(i)==0 || cons(i)==V
            special_true(i)=true;
        end
    end
    
    switch sum(special_true)
        case 1 %means only one is special
            coeff = zeros(2,2);
            if a==0 || a==V        

            coeff(1,:) = [r(3)+r(4)+r(7)+r(8) -r(8)           ];
            coeff(2,:) = [-r(8)               r(5)+r(6)+r(8)  ];
            rhs = [r(3);r(5)].*V + [r(7).*a;0];

            %solve
            sol = coeff\rhs;
            x = [a;sol];
            return
            elseif b==0 || b==V 

            coeff(1,:) = [r(1)+r(7)+r(2)    0];
            coeff(2,:) = [0       r(5)+r(6)+r(8)];
            rhs = [r(1);r(5)].*V + [r(7).*b;r(8).*b];
            %solve
            sol = coeff\rhs;
            x = [sol(1);b;sol(2)];
            return
            elseif c==0 || c==V
            coeff(1,:) = [r(1)+r(7)+r(2)    -r(7)        ];
            coeff(2,:) = [-r(7)             r(3)+r(4)+r(7)+r(8) ];


            rhs = [r(1);r(3)].*V + [0;r(8)*c];
            %solve
            sol = coeff\rhs;
            x = [sol;c];
            return
            else
                %do nothing
            end
        case 2  %2 are special
            if (a==0 || a==V) && (b==0 || b==V)
                % a and b are special
                coeff = [r(5)+r(6)+r(8)];
                rhs = [r(5)*V + r(8)*b];
                sol = coeff\rhs;
                x = [a;b;sol];
                return
            elseif(b==0 || b==V) && (c==0 || c==V)
                % b and c are special
                coeff = [r(1)+r(2)+r(7)];
                rhs = [r(1)*V + r(7)*b]
                sol = coeff\rhs;
                x = [sol;b;c];
                return
            elseif (a==0 || a==V) && (c==0 || c==V)
                % a and c are special
                coeff = [r(3)+r(4)+r(7)+r(8)];
                rhs = [r(3)*V + r(7)*a + r(8)*c];
                sol = coeff\rhs;
                x = [a;sol;c];
                return
            end            
        case 3  %3 are speical
            x = [a;b;c];
        case 0  %nothing is special. normal set of equations
            coeff = zeros(3,3);
            coeff(1,:) = [r(1)+r(7)+r(2)    -r(7)               0               ];
            coeff(2,:) = [-r(7)             r(3)+r(4)+r(7)+r(8) -r(8)           ];
            coeff(3,:) = [0                 -r(8)               r(5)+r(6)+r(8)  ];

            rhs = [r(1);r(3);r(5)].*V;

            x = coeff\rhs;
            
        otherwise
            error("Unknown error has occured")
    end
end

%best solution is to have no denominator terms
% function sol = voltage(V,R)
%     % Create the coeffecients matrix
%     M = [ R(2)*R(7) + R(1)*R(2) + R(1)*R(7), -R(1)*R(2),                                                        0;
%           -R(3)*R(4)*R(8),                   R(4)*R(7)*R(8) + R(3)*R(4)*R(8) + R(3)*R(4)*R(7) + R(3)*R(7)*R(8), -R(3)*R(4)*R(7);
%           0,                                 -R(5)*R(6),                                                        R(6)*R(8) + R(5)*R(6) + R(5)*R(8) ];
%     
%     y = V * [R(2)*R(7); R(4)*R(7)*R(8); R(6)*R(8)];
%     % Use the backslash operator to solve the system of linear equations
%     sol = M \ y;
% end