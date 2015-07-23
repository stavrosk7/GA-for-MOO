%Using Quadratic Programming on Portfolio Optimization Problems

% Load dataset stored in a MAT-file.
load('port5.mat','Correlation','stdDev_return','mean_return')
% Calculate covariance matrix from correlation matrix.
Covariance = Correlation .* (stdDev_return * stdDev_return');
nAssets = numel(mean_return); r = 0.002;     % number of assets and desired return
Aeq = ones(1,nAssets); beq = 1;              % equality Aeq*x = beq
Aineq = -mean_return'; bineq = -r;           % inequality Aineq*x <= bineq
lb = zeros(nAssets,1); ub = ones(nAssets,1); % bounds lb <= x <= ub
c = zeros(nAssets,1);                        % objective has no linear term; set it to zero

options = optimoptions('quadprog','Algorithm','interior-point-convex');

% Set additional options: turn on iterative display, and set a tighter optimality termination tolerance.
options = optimoptions(options,'Display','iter','TolFun',1e-10);

% Call solver and measure wall-clock time.
tic
[x1,fval1] = quadprog(Covariance,c,Aineq,bineq,Aeq,beq,lb,ub,[],options);
toc

% Plot results.
plotPortfDemoStandardModel(x1)

% Add group constraints to existing equalities.
Groups = blkdiag(ones(1,nAssets/3),ones(1,nAssets/3),ones(1,nAssets/3));
Aineq = [Aineq; -Groups];         % convert to <= constraint
bineq = [bineq; -0.3*ones(3,1)];  % by changing signs

% Call solver and measure wall-clock time.
tic
[x2,fval2] = quadprog(Covariance,c,Aineq,bineq,Aeq,beq,lb,ub,[],options);
toc

% Plot results, superimposed to results from previous problem.
plotPortfDemoGroupModel(x1,x2);

% Reset random stream for reproducibility.
rng(0,'twister');

nAssets = 1000; % desired number of assets
% Generate means of returns between -0.1 and 0.4.
a = -0.1; b = 0.4;
mean_return = a + (b-a).*rand(nAssets,1);
% Generate standard deviations of returns between 0.08 and 0.6.
a = 0.08; b = 0.6;
stdDev_return = a + (b-a).*rand(nAssets,1);
% Correlation matrix, generated using Correlation = gallery('randcorr',nAssets).
% (Generating a correlation matrix of this size takes a while, so we load
% a pre-generated one instead.)
load('correlationMatrixDemo.mat','Correlation');
% Calculate covariance matrix from correlation matrix.
Covariance = Correlation .* (stdDev_return * stdDev_return');

r = 0.15;                                     % desired return
Aeq = ones(1,nAssets); beq = 1;               % equality Aeq*x = beq
Aineq = -mean_return'; bineq = -r;            % inequality Aineq*x <= bineq
lb = zeros(nAssets,1); ub = ones(nAssets,1);  % bounds lb <= x <= ub
c = zeros(nAssets,1);                         % objective has no linear term; set it to zero

% Call solver and measure wall-clock time.
tic
x3 = quadprog(Covariance,c,Aineq,bineq,Aeq,beq,lb,ub,[],options);
toc

