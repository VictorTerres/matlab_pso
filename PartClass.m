classdef PartClass

    properties
        Part            % Vetor de valores reais que armazena a proporção utilizada de cada vetor. A soma de todos os valores deve ser 100%
        Tam             % Tamanho do vetor que representa a partícula (nº de vetores do problema)
        Fit             % Fitness da solução
        MelhorLocal     % Melhor posição local encontrada pela partícula e sua fitness
    end

    methods    
        function obj = PartClass(tam)
            obj.Tam = tam;
            obj.Part = zeros(1,tam);
            obj.MelhorLocal.Pos = zeros(1,tam);
            obj.MelhorLocal.Fit = inf;
            vetores = randperm(tam);
            obj.Part(vetores(1)) = rand(); 
            i = 2;
            
            while(sum(obj.Part) < 1 && i <= tam)
                obj.Part(vetores(i)) = rand();
                i = i + 1;
            end
            
            if(sum(obj.Part) < 1)
                gene = vetores(randi(tam));
                obj.Part(gene) = obj.Part(gene) + (1 - sum(obj.Part));
            end

            if(sum(obj.Part) > 1)
                obj.Part(vetores(i-1)) = obj.Part(vetores(i-1)) + (1 - sum(obj.Part));
            end
        end

        function obj = set.Part(obj, crom)
            obj.Part = crom;
            obj.Tam = size(crom,2);
        end
        
        function obj = set.Fit(obj, fit)
            obj.Fit = fit;
        end
         
        function obj = perturbar(obj)
            vetores = randperm(obj.Tam);
            am1=1;
            while(obj.Part(vetores(am1)) == 0)
                am1 = am1+1;
            end

            am2 = 1;

            if(am1 == am2)
                am2 = 2;    
            end
            
            limite = obj.Part(vetores(am1));
            
            if(limite + obj.Part(vetores(am2)) > 1)
                limite = 1 - obj.Part(vetores(am2));
            end

            alteracao = rand() * limite;
            
            obj.Part(vetores(am1)) = obj.Part(vetores(am1)) - alteracao;
            obj.Part(vetores(am2)) = obj.Part(vetores(am2)) + alteracao;
        end

        function obj = atualizarVelocidade(obj, CfPerturbacao, CfLocal, CfGlobal, melhorGlobal)
            txPerturbacao   = rand() * CfPerturbacao;
            txLocal     = rand() * CfLocal;
            txGlobal    = rand() * CfGlobal;
            
            total       = txPerturbacao + txLocal + txGlobal;
            
            txPerturbacao   = txPerturbacao / total;
            txLocal     = txLocal   / total;
            txGlobal    = txGlobal  / total;
            
            partPerturbada = obj.perturbar();
            
            partePerturbada = txPerturbacao * partPerturbada.Part;
            parteLocal  = txLocal   * obj.MelhorLocal.Pos;
            parteGlobal = txGlobal  * melhorGlobal.MelhorLocal.Pos;
            
            partAtualizada = partePerturbada + parteLocal + parteGlobal;
            
            obj.Part = partAtualizada;
        end
    end
end
