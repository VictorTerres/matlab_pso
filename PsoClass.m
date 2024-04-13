classdef PsoClass
    properties
        Dados           % Objeto do tipo DadosClass, contendo os dados do problema
        TamEnx          % Número de soluções no enxame
        CfPerturbacao	% Indica o quanto um local perturbado influenciará na velocidade da particula
        CfLocal         % Indica o quanto o melhor local influenciará na velocidade da particula
        CfGlobal        % Indica o quanto o melhor global influenciará na velocidade da particula
        Enx             % Armazena todas as soluções do enxame (cada iteração sempre inicia com um tamanho fixo)
        VetFitness      % Vetor que armezena as fitness de todas as soluções do enxame
        nIter           % Número total de iterações que serão executadas
        MaxStag         % Número total de iterações estagnadas antes do enxame ser perturbado
        Evolucao        % Historico contendo a fitness da melhor solução de cada geração
        MelhorGlobal    % Melhor local global alcançado pelo enxame na simulação 
    end
    
    methods
        function obj = PsoClass(dados,tamEnx,cfPert,cfLoc,cfGlo,nIter,maxStag)
            obj.Dados   = dados;
            obj.TamEnx  = tamEnx;
            obj.Enx     = cell(1, tamEnx);
            obj.nIter   = nIter;
            obj.MaxStag	= floor(nIter*maxStag);
            obj.VetFitness      = zeros(1, tamEnx);
            obj.CfPerturbacao   = cfPert;
            obj.CfLocal         = cfLoc;
            obj.CfGlobal        = cfGlo;
            
            for i=1:tamEnx
                obj.Enx{i} = PartClass(dados.NVetores);
                obj.Enx{i}.Fit = dados.fitness(obj.Enx{i}.Part);
                obj.VetFitness(1,i) = obj.Enx{i}.Fit;
            end
            
            obj.MelhorGlobal = PartClass(dados.NVetores);
            obj.MelhorGlobal.Fit = dados.fitness(obj.Enx{i}.Part);
        end
             
        function obj = ordenaEnx(obj)
            [VetFitOrdenado, index] = sort(obj.VetFitness);
            obj.VetFitness = VetFitOrdenado;
            obj.Enx = obj.Enx(index);
        end
             
        function obj = atualizarEnxame(obj)
            for i = 1:obj.TamEnx 
                obj.Enx{i}.atualizarVelocidade(obj.CfPerturbacao, obj.CfLocal, obj.CfGlobal, obj.MelhorGlobal);
                
                obj.Enx{i}.Fit = obj.Dados.fitness(obj.Enx{i}.Part);

                if obj.Enx{i}.Fit < obj.Enx{i}.MelhorLocal.Fit
                    obj.Enx{i}.MelhorLocal.Pos = obj.Enx{i}.Part;
                end

                if obj.Enx{i}.Fit < obj.MelhorGlobal.Fit
                    obj.MelhorGlobal = obj.Enx{i};
                end
            end
        end
        
        function obj = atualizarEstagnacao(obj)
            for i=1:obj.TamEnx
                novoPart = obj.Enx{i}.MelhorLocal.Pos * rand + obj.MelhorGlobal.MelhorLocal.Pos * rand;
                obj.Enx{i}.Part = novoPart/sum(novoPart);
                obj.Enx{i}.Fit = obj.Dados.fitness(obj.Enx{i}.Part);
                obj.VetFitness(i) = obj.Enx{i}.Fit;
            end
        end
            
        function obj = exe(obj)  
            disp('Iniciando a Otimização por Enxame de Partículas');
            obj.Evolucao = zeros(1, obj.nIter + 1);
            obj.ordenaEnx();
            obj.Evolucao(1) = obj.VetFitness(1);
            melhorFit = inf;
            estagnacao = 0;
            
            for i = 1:obj.nIter
                obj = obj.atualizarEnxame();
                obj = obj.ordenaEnx();
                obj.Enx = obj.Enx(1:obj.TamEnx);
                obj.VetFitness = obj.VetFitness(1:obj.TamEnx);
                obj.Evolucao(i+1) = obj.VetFitness(1);
                
                if obj.VetFitness(1) < melhorFit
                    melhorFit = obj.VetFitness(1);
                    estagnacao = 0;
                else
                    estagnacao = estagnacao + 1;
                end

                if estagnacao > obj.MaxStag
                     obj = obj.atualizarEstagnacao();
                     estagnacao = 0;
                end
                
                if mod(i, 100) == 0
                    disp(['Iteração ', num2str(i)]);
                    disp('Fitness:');
                    disp(obj.VetFitness(1));
                end
            end
            
            disp('Execução concluída');
            
        end
        
        function plotEvo(obj)
            plot((0:obj.nIter), obj.Evolucao);
            title('Evolução do Enxame de Partículas');
            ylabel('Fitness');
            xlabel('Iteração');
            xlim([0, obj.nIter]);
        end
    end
end
