% % Script para rodar o Particle Swarm Optimization e mostrar gráficos dos resultados
% 
% % Carregar os dados
% load('dados.mat');
% 
% % O objetivo é encontrar um vetor que se aproxime do 1°
% dados = DadosClass(HSI_all(2:end,:), HSI_all(1,:));
% 
% % Configura o PSO com: conjunto de dados, tamEnxame=20, cfPert=30%,
% % cfLoc = 30%, cfGlo = 40%, nIter=100, maxStag=20%;
% pso = PsoClass(dados, 30, 0.3, 0.3, 0.4, 100, 0.2);
% 
% % Executando o algoritmo PSO
% pso = pso.exe();
% 
% % % Gráfico mostrando a evolução
% pso.plotEvo();
% disp('Pressione alguma tecla para continuar');
% pause();
% 
% close;

%------------------------------------------------------------------------

% Script para rodar a Otimização por Enxame e mostrar gráficos dos resultados

% Carregar os dados
load('dados.mat');

% O objetivo é encontrar uma mistura que se aproxime da 1ª amostra
dados = DadosClass(HSI_all(2:end,:), HSI_all(1,:));

% Inicializar vetores para armazenar os valores de fitness e os tempos de execução
numIteracoes = 30;
fitnessIteracoes = zeros(1, numIteracoes);
tempoIteracoes = zeros(1, numIteracoes);

for i = 1:numIteracoes
    disp(['Executando iteração ', num2str(i)]);
    
    % Iniciar o cronômetro
    tic;
 
    % Configura o PSO com: conjunto de dados, tamEnxame=20, txMutacao=30%,
	% txLocal = 30%, txGlobal = 40%, nGer=100, maxStag=20%;
	pso = PsoClass(dados, 20, 0.3, 0.3, 0.4, 100, 0.2);

    % Executar o AG
    pso = pso.exe();
    
    % Armazenar o valor de fitness e o tempo de execução
    fitnessIteracoes(i) = pso.Enx{1}.Fit;
    tempoIteracoes(i) = toc; % Parar o cronômetro e armazenar o tempo
end

% Mostrar gráfico dos valores de fitness ao longo das iterações
figure;
plot(1:numIteracoes, fitnessIteracoes, 'b.-');
xlabel('Iteração');
ylabel('Fitness');
title('Fitness ao longo das iterações da PSO');
grid on;

% Mostrar gráfico dos tempos de execução ao longo das iterações
figure;
plot(1:numIteracoes, tempoIteracoes, 'r.-');
xlabel('Iteração');
ylabel('Tempo de Execução (segundos)');
title('Tempo de Execução ao longo das iterações da PSO');
grid on;